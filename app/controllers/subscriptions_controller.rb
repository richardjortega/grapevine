class SubscriptionsController < ApplicationController

  def create
  	@subscription = Subscription.new params[:subscription]
  	@user  = User.create!(params[:user])
  	@subscription.user = @user

  	@plan = Plan.find params[:subscription][:plan_id]
    
  	if @subscription.save_without_payment
      redirect_to thankyou_path
	    NotifyMailer.delay.free_signup(@subscription.user).deliver
	    NotifyMailer.delay.update_grapevine_team(@subscription.user, "New FREE customer signed up").deliver
  	else
  		flash.now[:error] = "Unable to add your subscription, this has been reported to the Grapevine team"
  		render template: 'static_pages/signup'
  	end

  end

  def update
    @subscription = current_user.subscription
    current_plan = current_user.plan.identifier

    if @subscription.update_stripe params[:subscription]
      flash.now[:error] = "Thanks for signup for Grapevine, you'll membership will be billed monthly."
      if current_plan == 'gv_free' && params[:subscription][:plan] == 'gv_30'
        NotifyMailer.paid_signup(@subscription.user).deliver
        NotifyMailer.update_grapevine_team(@subscription.user, "Customer Upgraded to PAID").deliver
      end
      redirect_to billing_path
    else
      flash.now[:error] = "Unable to add your subscription, this has been reported to the Grapevine team"
      redirect_to :back
    end

  end



end
