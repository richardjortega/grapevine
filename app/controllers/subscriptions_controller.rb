class SubscriptionsController < ApplicationController
  # before_filter :format_phone_number, :on => :create

  def create
  	@subscription = Subscription.new params[:subscription]
    #Note need to break out user so that it isn't saved if issue with stripe.
  	@user	= User.create!(params[:user])
  	@subscription.user  = @user

  	@plan = Plan.find params[:subscription][:plan_id]
    
  	if @subscription.save_without_payment
  		redirect_to thankyou_path
	    NotifyMailer.free_signup(@subscription.user).deliver
	    NotifyMailer.new_customer(@subscription.user).deliver
  	else
  		flash.now[:error] = "Unable to add your subscription, this has been reported to the Grapevine team"
  		render template: 'static_pages#signup'
  	end

  end

# private

#   def format_phone_number
#     #will remove all but integers, only if a phone number has been provided
#     params[:user][:phone_number].gsub!(/[^0-9]/,"") if params[:user][:phone_number].present?
#   end

end
