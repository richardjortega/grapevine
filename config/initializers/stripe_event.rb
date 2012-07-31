### Handle Stripe's Webhooks
# stripe_event (gem) is built on the ActiveSupport::Notifications API. 
# Incoming webhook requests are authenticated by retrieving the event object from Stripe. 
# Authenticated events are published to subscribers.

StripeEvent.registration do
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
		if event.status == 'unpaid' 
			handle_unpaid_customer event.data.object
		else render :nothing => true, :status => 200
		end
	end

	# Stripe webhooks we're not monitoring or storing
	# TODO:: store nonrelevant webhook events into a logging system
	subscribe 'invoice.created', 
			  'invoice.updated',
			  'plan.created', 
			  'plan.updated', 
			  'customer.subscription.created', 
			  'charge.succeeded', 
			  'charge.failed',
			  'customer.created' do |event|
		render :nothing => true, :status => 200
	end

end

private

# Inform user of failed payment. Accepts Stripe Invoice object
def handle_failed_charge(invoice)
	user = User.find_by_stripe_customer_token(invoice.customer)
	debugger
	NotifyMailer.unsuccessfully_invoiced(user).deliver
end

# Provide user with payment receipt. Accepts Stripe Invoice object
def handle_successful_charge(invoice)
	user = User.find_by_stripe_customer_token(invoice.customer)
	user.subscription.status = true
	user.save!
	
	NotifyMailer.successfully_invoiced(invoice, user).deliver
end

# Send an email to the customer informing them the trial is ending in 3 days
def handle_trial_ending(subscription)
	user = User.find_by_stripe_customer_token(subscription.customer)
	NotifyMailer.trial_ending(user).deliver
end

# Suspend user for not paying after 3 retries to credit card
# Same for trials that expire (on the 31st day)
def handle_unpaid_customer(subscription)
	user = User.find_by_stripe_customer_token(subscription.customer)
	user.subscription.status = false
	user.subscription.status_info = subscription.status
	user.save!

	NotifyMailer.account_expired(user).deliver
end