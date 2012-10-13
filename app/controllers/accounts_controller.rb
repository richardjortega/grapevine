class AccountsController < ApplicationController

	def index
      @plan = current_user.subscription.plan
      @location = current_user.locations[0]

	end

end
