# Setup behavior for Stripe
# Set keys (will change based on production or local dev)

stripe = if ENV['STRIPE_PUBLISHABLE_KEY'] and ENV['STRIPE_SECRET_KEY']
  { app_id: ENV['STRIPE_PUBLISHABLE_KEY'], secret: ENV['STRIPE_SECRET_KEY'] }
else
  path = Rails.root.join *%w[ config stripe.yml ]
  file = File.open path
  YAML.load(file).with_indifferent_access
end

STRIPE_PUBLIC_KEY = stripe[:STRIPE_PUBLISHABLE_KEY]
Stripe.api_key    = stripe[:STRIPE_SECRET_KEY]

# Stripe Webhook Handler
# Hooks can only be used with a live URL
# Recommended testing options:
## pagekite.me, showoff.io, localtunnel.com

StripeEvent.registration do
	subscribe 'invoice.payment_failed' do |event|
		handle_failed_charge event
	end

	subscribe 'invoice.payment_succeeded' do |event|
		handle_successful_charge event		
	end
end

private

	def handle_successful_charge(invoice)
		@user = User.find_by_stripe_id(invoice.customer)
		@user.status = true
		@user.save!
		
		# Notify the User's charge was Successful and CC Grapevine- Support
		NotifyMailer.successfully_invoiced(invoice, @user).deliver
	end

	def handle_failed_charge(invoice)
		@user = User.find_by_stripe_id(invoice.customer)
		@user.status = false
		@user.save!

		# Notify the User's charge was Failed and CC Grapevine- Support
		NotifyMailer.unsuccessfully_invoiced(invoice, @user).deliver
	end



