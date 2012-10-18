### Handle Stripe's Webhooks
# stripe_event (gem) is built on the ActiveSupport::Notifications API. 
# Incoming webhook requests are authenticated by retrieving the event object from Stripe. 
# Authenticated events are published to subscribers.

StripeEvent.setup do
	require 'pp'

	subscribe 'invoice.payment_failed' do |event|
		handle_failed_charge event.data.object
	end

	subscribe 'invoice.payment_succeeded' do |event|
		handle_successful_charge event.data.object
	end

	subscribe 'customer.subscription.trial_will_end' do |event|
		handle_trial_ending event.data.object
	end

	# Update customer's plan to whatever Stripe lets us know.
	# TODO: Will be used when user's accounts update
	subscribe 'customer.subscription.updated' do |event|
		debugger
		case event.data.object.status
			when 'unpaid'
				handle_unpaid_customer event.data.object
			when 'canceled'
				handle_canceled_customer event.data.object
			else update_customer_subscription
		end
	end

end

private

	# Inform user of failed payment. Accepts Stripe Invoice object
	def handle_failed_charge(invoice)
		user = Subscription.find_by_stripe_customer_token(invoice.customer)
		NotifyMailer.unsuccessfully_invoiced(user).deliver
		NotifyMailer.update_grapevine_team(user, "User has failed a charge").deliver
	end

	# Provide user with payment receipt. Accepts Stripe Invoice object
	def handle_successful_charge(invoice)
		user = Subscription.find_by_stripe_customer_token(invoice.customer)
		user.subscription.status = true
		user.save!
		
		NotifyMailer.successfully_invoiced(invoice, user).deliver
	end

	# Send an email to the customer informing them the trial is ending in 3 days
	def handle_trial_ending(subscription)
		user = Subscription.find_by_stripe_customer_token(subscription.customer)
		NotifyMailer.trial_ending(user).deliver
		NotifyMailer.update_grapevine_team(user, "User has 3 days left on trial").deliver
	end

	# Handle canceled user
	def handle_canceled_customer(subscription)
		user = Subscription.find_by_stripe_customer_token(subscription.customer)
		user.subscription.status = false
		user.subscription.status_info = subscription.status
		user.save!

		# TODO: create account canceled email
		NotifyMailer.account_canceled(user).deliver
		NotifyMailer.update_grapevine_team(user, "User has just canceled").deliver
	end

	# Suspend user for not paying after 3 retries to credit card
	# Same for trials that expire (on the 31st day)
	def handle_unpaid_customer(subscription)
		user = Subscription.find_by_stripe_customer_token(subscription.customer)
		user.subscription.status = false
		user.subscription.status_info = subscription.status
		user.save!

		NotifyMailer.account_expired(user).deliver
		NotifyMailer.update_grapevine_team(user, "User has been set to unpaid status").deliver
	end

	# Update all items on customer to match stripe webhook
	def update_customer_subscription(subscription)
		user = Subscription.find_by_stripe_customer_token(subscription.customer)
		user.subscription.status_info = subscription.status
		user.subscription.start_date = subscription.start
		user.subscription.current_period_start = subscription.current_period_start
		user.subscription.current_period_end = subscription.current_period_end
		user.subscription.trial_start = subscription.trial_start if subscription.trial_start.present?
		user.subscription.trial_end = subscription.trial_end if subscription.trial_end.present?
	end
