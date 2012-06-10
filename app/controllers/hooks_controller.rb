class HooksController < ApplicationController

	protect_from_forgery :except => :receiver

	require 'json'
	require 'stripe'

	#Hooks can only be used with a live URL
	# Recommended testing options:
	## pagekite.me - free trial
	## showoff.io - free for 5 mins
	## localtunnel.com - free, major issue - randomizies same URLs so sometimes your server has to handle other random webhooks from other user's services. 

	Stripe.api_key = '<%= ENV["STRIPE_SECRET_KEY"] %>'

	def receiver
		#webhooking like a ninja
		data = JSON.parse request.body.read, :symbolize_names => true

		#Always helpful to see data
		p data

		# Identify the event ID and it's type
		puts "Received event with ID: #{data[:id]} Type: #{data[:type]}"

		# Retreiving the event from the Stripe API guarantees its authenticity (Recommended by Stripe)
		# Because of this check "Test Webhook" can't be used from Stripe dashboard as it sends all event ids as "000s"
		event = Stripe::Event.retrieve(data[:id])

		# Stop webhooks we're not using, but return a 200 OK status so Stripe won't resend.
		if event.type == "invoice.created" or "plan.created" or "customer.subscription.created" or "charge.succeeded" or "customer.created"
			render :nothing => true, :status => 200
		end

		# Identify if the invoice was successful, then make user active in system
		if event.type == "invoice.payment_succeeded"
			make_active(event.data.object)
		end

		# Identify if the invoice failed, then make user active in system
		if event.type == "invoice.payment_failed"
			make_inactive(event.data.object)
		end
	end

	def make_active(invoice)
		@user = User.find_by_stripe_id(invoice.customer)
		@user.subscribed = true
		@user.save!
		
		# Notify the User's charge was Successful and CC Grapevine- Support
		NotifyMailer.successfully_invoiced(invoice, @user).deliver
	end

	def make_inactive(invoice)
		@user = User.find_by_stripe_id(invoice.customer)
		@user.subscribed = false
		@user.save!

		# Notify the User's charge was Failed and CC Grapevine- Support
		NotifyMailer.unsuccessfully_invoiced(invoice, @user).deliver
	end

end
