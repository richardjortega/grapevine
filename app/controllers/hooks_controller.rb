class HooksController < ApplicationController
	# for straight up testing
	Stripe.api_key = "tJhooWqaOtgRuLxkGogSLTL3sLxEU4ak"

	#for production
	#Stripe::api_key = ENV['STRIPE_SECRET_KEY']

	require 'json'
	require 'stripe'

	def receiver
		data = JSON.parse(request.body.read), :symbolize_names => true

		p data

		puts "Received event with ID: #{data[:id]} Type: #{data[:type]}"

		#Retreiving the event from the Stripe API guarantees its authenticity
		event = Stripe::Event.retrieve(data[:id])

		# This will send receipts on successful invoices
		if event.type == "invoice.payment_succeeded"
			#NotifyMailer.email_invoice_receipt(event.data.object)
			make_active(event)
		end

		if event.type == "invoice.payment_failed"
			make_inactive(event)
		end
	end

	def make_active(event)
		@user = User.find_by_stripe_id(data['data']['object']['customer'])
		if @user.subscribed == false
			@user.subscribed == true
			@user.save!
		end
	end

	def make_inactive(event)
		@user = User.find_by_stripe_id(data['data']['object']['customer'])
		if @user.subscribed == true
			@user.subscribed == false
			@user.save!
		end
	end


end
