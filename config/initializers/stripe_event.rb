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

	# Update customer's plan to whatever Stripe lets us know.
	# TODO: Will be used when user's accounts update
	subscribe 'customer.subscription.updated' do |event|
		case event.data.object.status
			# when 'unpaid'
			# 	handle_unpaid_customer event.data.object
			when 'canceled'
				handle_canceled_customer event.data.object
			else
				update_customer_subscription event.data.object
		end
	end

end

private

	# Inform user of failed payment. Accepts Stripe Invoice object
	def handle_failed_charge(charge)
		begin
		invoice_id = charge.invoice
		invoice = Stripe::Invoice.retrieve(invoice_id)
		subscription = Subscription.find_by_stripe_customer_token(invoice.customer)
		
		user = subscription.user
		NotifyMailer.unsuccessfully_charged(invoice, user).deliver
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
		if subscription.status_info.present?
			if subscription.status_info == 'trialing' 
				return false
			else
				subscription.status = true
				subscription.save!
				
				user = subscription.user
				NotifyMailer.successfully_charged(invoice, user).deliver
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
		NotifyMailer.trial_ending(user).deliver
		NotifyMailer.update_grapevine_team(user, "User has 3 days left on trial").deliver
	end

	# Handle canceled user
	def handle_canceled_customer(customer_subscription)
		subscription = Subscription.find_by_stripe_customer_token(customer_subscription.customer)
		subscription.status = false
		subscription.status_info = customer_subscription.status
		subscription.save!

		user = subscription.user
		NotifyMailer.account_canceled(user).deliver
		NotifyMailer.update_grapevine_team(user, "User has just canceled").deliver
	end

	# Suspend user for not paying after 3 retries to credit card
	# Same for trials that expire (on the 31st day)
	def handle_unpaid_customer(customer_subscription)
		subscription = Subscription.find_by_stripe_customer_token(customer_subscription.customer)
		subscription.status = false
		subscription.status_info = customer_subscription.status
		subscription.save!

		user = subscription.user
		NotifyMailer.account_expired(user).deliver
		NotifyMailer.update_grapevine_team(user, "User has been set to unpaid status").deliver
	end

	# Update all items on customer to match stripe webhook
	def update_customer_subscription(customer_subscription)
		subscription = Subscription.find_by_stripe_customer_token(customer_subscription.customer)
		if subscription
			subscription.status_info = customer_subscription.status
			subscription.start_date = customer_subscription.start
			subscription.current_period_start = customer_subscription.current_period_start
			subscription.current_period_end = customer_subscription.current_period_end
			if customer_subscription.trial_start.present?
				subscription.trial_start = customer_subscription.trial_start
			end
			if customer_subscription.trial_end.present?
				subscription.trial_end = customer_subscription.trial_end
			end
			subscription.save!
		end
	end
