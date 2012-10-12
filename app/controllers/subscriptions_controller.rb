class SubscriptionsController < ApplicationController

  def create
  	@subscription = Subscription.new params[:subscription]
    #Note need to break out user so that it isn't saved if issue with stripe.
  	@user	= User.create!(params[:user])
  	@subscription.user  = @user

  	@plan = Plan.find params[:subscription][:plan_id]
    
  	if @subscription.save_without_payment
  		redirect_to thankyou_path
	    NotifyMailer.free_signup(@subscription.user).deliver

	    NotifyMailer.update_grapevine_team(@subscription.user, "New customer signed up").deliver
  	else
  		flash.now[:error] = "Unable to add your subscription, this has been reported to the Grapevine team"
  		render template: 'static_pages#signup'
  	end

  end

end
