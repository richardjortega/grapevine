class SubscriptionsController < ApplicationController
 
  def create
  	@subscription 		= Subscription.new params[:subscription]
  	@subscription.user	= current_user

  	@plan = Plan.find params[:subscription][:plan_id]

  	if @subscription.save_without_payment
  		flash[:success]	= "Thank you trying out Grapevine Free 30 Day Trial!"
  		redirect_to root_path
  	else
  		flash.now[:error] = "Unable to add your subcription, this has been reported to the Grapevine team"
  		render template: 'static_pages#home'
  	end

  end

end
