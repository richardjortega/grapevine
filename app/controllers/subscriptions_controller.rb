class SubscriptionsController < ApplicationController

  def create
  	@subscription 		= Subscription.new params[:subscription]
  	user				= User.create! params[:user]
  	@subscription.user  = user
  	user.locations << Location.create!(params[:location])


  	@plan = Plan.find params[:subscription][:plan_id]
  	debugger

  	if @subscription.save_without_payment
  		flash[:success]	= "Thank you trying out Grapevine Free 30 Day Trial!"
  		redirect_to root_path
  		# Deliver the signup_email
	    NotifyMailer.free_signup(@subscription.user).deliver
	    # Send 'ol Erik a notice of a new customer signed up upon completion
	    NotifyMailer.new_customer(@subcription.user).deliver
  	else
  		flash.now[:error] = "Unable to add your subcription, this has been reported to the Grapevine team"
  		render template: 'static_pages#home'
  	end

  end

end
