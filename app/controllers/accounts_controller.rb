class AccountsController < ApplicationController

	def index
      @plan = current_user.subscription.plan
      @location = current_user.locations[0]
      @subscription = current_user.subscription

      if current_user.subscription.status_info.nil?
      	@status = "No status info available, please contact Grapevine"
      else
      	@status = current_user.subscription.status_info.capitalize
      end

      if @subscription.start_date.nil?
      	@start_date = "No start date found, please contact Grapevine"
      else
      	@start_date = Time.at(@subscription.start_date).to_date.strftime("%A, %B %d, %Y")
      end
      
	end

end
