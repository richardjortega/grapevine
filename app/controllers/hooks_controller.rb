class HooksController < ApplicationController
	#for production
	#Stripe::api_key = ENV['STRIPE_SECRET_KEY']

	require 'json'
	require 'stripe'

	# for straight up testing
	Stripe.api_key = "tJhooWqaOtgRuLxkGogSLTL3sLxEU4ak"

	def receiver
		#webhooking like a ninja
		data = JSON.parse request.body.read, :symbolize_names => true

		p data

		puts "Received event with ID: #{data[:id]} Type: #{data[:type]}"

		#Retreiving the event from the Stripe API guarantees its authenticity
		event = Stripe::Event.retrieve(data[:id])

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
			# Notify Grapevine Support that a user can been charged
			NotifyMailer.alert_invoice_succeeded(@user)
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
