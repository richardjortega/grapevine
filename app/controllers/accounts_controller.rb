class AccountsController < ApplicationController

	def index
      @plan = current_user.subscription.plan

	end

end
