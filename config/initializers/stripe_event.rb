### Handle Stripe's Webhooks
# stripe_event (gem) is built on the ActiveSupport::Notifications API. 
# Incoming webhook requests are authenticated by retrieving the event object from Stripe. 
# Authenticated events are published to subscribers.

StripeEvent.setup do
	require 'pp'

	subscribe 'charge.failed' do |event|
		handle_failed_charge event.data.object
	end

	subscribe 'charge.succeeded' do |event|
		handle_successful_charge event.data.object
	end

	subscribe 'customer.subscription.trial_will_end' do |event|
		handle_trial_ending event.data.object
	end

	# Customer updated (like adding a new card)
	subscribe 'customer.updated' do |event|
		handle_customer_updated event.data.object
	end

	# New plans created will now update system
	subscribe 'plan.created' do |event|
		handle_plan_created event.data.object
	end

	# Update customer's plan to whatever Stripe lets us know.
	subscribe 'customer.subscription.updated' do |event|
		case event.data.object.status
			when 'unpaid'
			 	handle_unpaid_customer event.data.object
			when 'canceled'
				handle_canceled_customer event.data.object
			else
				update_customer_subscription event.data.object
		end
	end

end

private
	
	def format_amount(amount)
	    sprintf('$%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
	end

	def handle_plan_created(plan)
		begin
		Plan.create({:amount => plan.amount,
					   :currency 	=> plan.currency,
					   :interval	=> plan.interval,
					   :name 		=> plan.name,
					   :identifier  => plan.id})
		rescue => e
			puts "#{e.message}"
		end
	end
	
	# Handles any new card changes
	def handle_customer_updated(customer)
		subscription = Subscription.find_by_stripe_customer_token(customer.id)
		if subscription
			if customer.active_card.present?
				active_card = customer.active_card
				exp_month = active_card.exp_month
				exp_year = active_card.exp_year
				last_four = active_card.last4
				card_type = active_card.type
				subscription.update_attributes({:last_four => last_four, 
												:card_type => card_type, 
												:exp_month => exp_month, 
												:exp_year  => exp_year })
			end
		end
	end

	# Inform user of failed payment. Accepts Stripe Invoice object
	def handle_failed_charge(charge)
		begin
		invoice_id = charge.invoice
		invoice = Stripe::Invoice.retrieve(invoice_id)
		subscription = Subscription.find_by_stripe_customer_token(invoice.customer)
		
		user = subscription.user
		NotifyMailer.delay.unsuccessfully_charged(invoice, user)
		rescue => e
			puts "#{e.message}"
		end
	end

	# Provide user with payment receipt. Accepts Stripe Invoice object
	def handle_successful_charge(charge)
		begin
		invoice_id = charge.invoice
		invoice = Stripe::Invoice.retrieve(invoice_id)
		subscription = Subscription.find_by_stripe_customer_token(invoice.customer)
		### Track that user was billed successfully - KM
		user = subscription.user
		plan = user.plan
		subscription_amount = format_amount(invoice.total)
		DelayedKiss.alias(user.full_name, user.email)
        DelayedKiss.record(user.email, 'Billed', {'Billing_Amount' => "#{subscription_amount}", 
        											  'Plan_Name' => "#{plan.name}",
                                                      'Plan_Identifier' => "#{plan.identifier}", })
		if subscription.status_info.present?
			if subscription.status_info == 'trialing' 
				return false
			else
				subscription.status = true
				subscription.save!
				
				user = subscription.user
				NotifyMailer.delay.successfully_charged(invoice, user)
			end
		end

		rescue => e
			puts "#{e.message}"
		end
	end

	# Send an email to the customer informing them the trial is ending in 3 days
	def handle_trial_ending(customer_subscription)
		subscription = Subscription.find_by_stripe_customer_token(customer_subscription.customer)
		
		user = subscription.user
		NotifyMailer.delay.trial_ending(user)
		NotifyMailer.delay.update_grapevine_team(user, "User has 3 days left on trial")
	end

	# Handle canceled user
	def handle_canceled_customer(customer_subscription)
		subscription = Subscription.find_by_stripe_customer_token(customer_subscription.customer)
		subscription.status = false
		subscription.status_info = customer_subscription.status
		subscription.save!

		user = subscription.user
		NotifyMailer.delay.account_canceled(user)
		NotifyMailer.delay.update_grapevine_team(user, "User has just canceled")
	end

	# Suspend user for not paying after 3 retries to credit card
	def handle_unpaid_customer(customer_subscription)
		subscription = Subscription.find_by_stripe_customer_token(customer_subscription.customer)
		subscription.status = false
		subscription.status_info = customer_subscription.status
		subscription.save!

		user = subscription.user
		NotifyMailer.delay.account_expired(user)
		NotifyMailer.delay.update_grapevine_team(user, "User has been set to unpaid status")
	end

	# Update all items on customer to match stripe webhook
	def update_customer_subscription(customer_subscription)
		subscription = Subscription.find_by_stripe_customer_token(customer_subscription.customer)
		if subscription
			# Update customer with new plan
			if customer_subscription.plan.present?
				active_plan_id = customer_subscription.plan.id
				subscription.plan = Plan.find_by_identifier(active_plan_id)
				subscription.save!
			end

			subscription.update_attributes({:status 				=> true,
											:status_info 			=> customer_subscription.status,
											:start_date				=> customer_subscription.start,
											:current_period_start	=> customer_subscription.current_period_start,
											:current_period_end		=> customer_subscription.current_period_end })
			
			## Just in case later in the future we have trialing...
			if customer_subscription.trial_start.present?
				subscription.trial_start = customer_subscription.trial_start
			end
			if customer_subscription.trial_end.present?
				subscription.trial_end = customer_subscription.trial_end
			end
			subscription.save!
		end
	end
