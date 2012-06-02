class HooksController < ApplicationController
	
	Stripe::api_key = ENV['STRIPE_SECRET_KEY']

	require 'json'
	require 'stripe'

	def receiver
		#webhooking like a ninja
		data = JSON.parse request.body.read, :symbolize_names => true

		p data

		puts "Received event with ID: #{data[:id]} Type: #{data[:type]}"

		#Retreiving the event from the Stripe API guarantees its authenticity
		event = Stripe::Event.retrieve(data[:id])

		#Retreive and store the invoice of the customer

		# This will send receipts on successful invoices
		if event.type == "invoice.payment_succeeded"
			make_active(event.data.object)
		end

		if event.type == "invoice.payment_failed"
			make_inactive(event.data.object)
		end
	end

	def make_active(event)
		@user = User.find_by_stripe_id(event.customer)
		if @user.subscribed == false
			@user.subscribed = true
			@user.save!
			
			#Retreive and store the invoice of the customer
			customer = Stripe::Customer.retrieve(invoice.customer)

			# Notify Grapevine Support that a user can been charged
			NotifyMailer.invoice_succeeded(event, customer).deliver
		end
	end

	def make_inactive(event)
		@user = User.find_by_stripe_id(event.customer)
		if @user.subscribed == true
			@user.subscribed = false
			@user.save!

			# Need to create a notifcation for invoices that failed
		end
	end


end
