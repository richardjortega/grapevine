class AccountsController < ApplicationController

	def index
      @plan = current_user.subscription.plan
      @location = current_user.locations[0]
      @subscription = current_user.subscription
      @status = current_user.subscription.status_info
      @start_date = Time.at(@subscription.start_date).to_date.strftime("%A, %B %d, %Y")
	end

end
