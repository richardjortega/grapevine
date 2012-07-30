### Handle Stripe's Webhooks
# stripe_event is built on the ActiveSupport::Notifications API. 
# Incoming webhook requests are authenticated by retrieving the event object from Stripe. 
# Authenticated events are published to subscribers.

StripeEvent.registration do
	require 'pp'

	subscribe 'invoice.payment_failed' do |event|
		pp event
		handle_failed_charge event
	end

	subscribe 'invoice.payment_succeeded' do |event|
		pp event
		handle_successful_charge event		
	end

	subscribe 'customer.subscription.trial_will_end' do |event|
		pp event
		handle_trial_ending event
	end

	# Update customer's plan to whatever Stripe lets us know.
	# TODO: Will be used when user's accounts update
	subscribe 'plan.updated' do |event|
		pp event
	end

	# Stripe webhooks we're not monitoring
	subscribe 'invoice.created', 'plan.created', 'plan.updated', 'customer.subscription.created', 'charge.succeeded', 'customer.created' do |event|
		event.render :nothing => true, :status => 200
	end

end

private

	# Modify user's account to be active, accepts Stripe event object
	def handle_successful_charge(invoice)
		user = User.find_by_stripe_customer_token(invoice.customer)
		user.status = true
		user.save!
		
		# Notify the User's charge was Successful and CC Grapevine- Support
		NotifyMailer.successfully_invoiced(invoice, user).deliver
	end

	# Modify user's account to be active, accepts Stripe event object
	def handle_failed_charge(invoice)
		user = User.find_by_stripe_customer_token(invoice.customer)
		user.status = false
		user.save!

		# Notify the User's charge was Failed and CC Grapevine- Support
		NotifyMailer.unsuccessfully_invoiced(invoice, user).deliver
	end

	def update_plan_status(plan)
		user = User.find_by_stripe_customer_token(plan.customer)
		new_plan_status = plan.status
		user.subscription.status = new_plan_status
	end

	# Send an email to the customer informing them the trial is ending in 3 days
	def handle_trial_ending(customer)

	end

	# Send email informing the customer that the trial has expired
	def handle_trial_expired(customer)

	end