class SubscriptionsController < ApplicationController
  force_ssl :except => :create
  
  def create
  	@subscription = Subscription.new params[:subscription]
  	@user  = User.create!(params[:user])
  	@subscription.user = @user

  	@plan = Plan.find params[:subscription][:plan_id]
    
  	if @subscription.save_without_payment
      redirect_to thank_you_path
      unless params[:user][:multi_location] == 'true'
        DelayedKiss.alias(@user.full_name, @user.email)
        DelayedKiss.record(@user.email, 'Signed Up', {'Plan_Name' => "#{@plan.name}", 
                                                      'Plan_Identifier' => "#{@plan.identifier}", })

  	    NotifyMailer.delay.free_signup(@subscription.user)
  	    NotifyMailer.delay.update_grapevine_team(@subscription.user, "New FREE customer signed up")
      end
  	else
  		flash.now[:error] = "Unable to add your subscription, this has been reported to the Grapevine team"
  		render template: 'static_pages/signup'
  	end

  end

  def update
    @subscription = current_user.subscription
    current_plan = current_user.plan.identifier

    if @subscription.delay.update_stripe params[:subscription]
      flash.now[:error] = "Thanks for signup for Grapevine, you'll membership will be billed monthly."
      if current_plan == 'gv_free' && params[:subscription][:plan] == 'gv_30'
        @plan = Plan.find_by_identifier(params[:subscription][:plan])
        DelayedKiss.alias(current_user.full_name, current_user.email)
        DelayedKiss.record(current_user.email, 'Upgraded', {'Plan_Name' => "#{@plan.name}", 
                                                      'Plan_Identifier' => "#{@plan.identifier}" })
        
        NotifyMailer.delay.paid_signup(@subscription.user)
        NotifyMailer.delay.update_grapevine_team(@subscription.user, "Customer Upgraded to PAID")
      end
      redirect_to upgrade_thank_you_path
    else
      flash.now[:error] = "Unable to add your subscription, this has been reported to the Grapevine team"
      redirect_to :back
    end

  end



end
