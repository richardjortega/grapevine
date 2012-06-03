class HooksController < ApplicationController

	require 'json'
	require 'stripe'

	#Hooks can only be used with a live URL (production, localtunnel, or herokuapp)
	
	Stripe::api_key = ENV['STRIPE_SECRET_KEY']

	def receiver
		#webhooking like a ninja
		data = JSON.parse request.body.read, :symbolize_names => true

		p data

		puts "Received event with ID: #{data[:id]} Type: #{data[:type]}"

		#Retreiving the event from the Stripe API guarantees its authenticity
		event = Stripe::Event.retrieve(data[:id])

		# Identify wether the invoice was successful or failed
		if event.type == "invoice.payment_succeeded"
			make_active(event.data.object)
		end

		if event.type == "invoice.payment_failed"
			make_inactive(event.data.object)
		end
	end

	def make_active(invoice)
		@user = User.find_by_stripe_id(invoice.customer)
		if @user.subscribed == false
			@user.subscribed = true
			@user.save!

			# Notify the User's charge was Successful and CC Grapevine- Support
			NotifyMailer.invoice_succeeded(invoice, @user).deliver
		end
	end

	def make_inactive(invoice)
		@user = User.find_by_stripe_id(invoice.customer)
		if @user.subscribed == true
			@user.subscribed = false
			@user.save!

			# Notify the User's charge was Failed and CC Grapevine- Support
			NotifyMailer.invoice_failed(invoice, @user).deliver
		end
	end


end
