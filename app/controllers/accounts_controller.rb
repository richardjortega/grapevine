class AccountsController < ApplicationController

	def index
            @plan = current_user.subscription.plan
            @location = current_user.locations[0]
            @subscription = current_user.subscription

            if current_user.subscription.status_info
                  @status = current_user.subscription.status_info.capitalize
            else
                  @status = "No status info available, please contact Grapevine"
            end

            if @subscription.start_date
                  @start_date = Time.at(@subscription.start_date).to_date.strftime("%A, %B %d, %Y")
            else
                  @start_date = "No start date found, please contact Grapevine"
            end
            
	end

      def upgrade
            @plan = current_user.subscription.plan
            @location = current_user.locations[0]
            @subscription = current_user.subscription

            if current_user.subscription.status_info
                  @status = current_user.subscription.status_info.capitalize
            else
                  @status = "No status info available, please contact Grapevine"
            end

            if @subscription.start_date
                  @start_date = Time.at(@subscription.start_date).to_date.strftime("%A, %B %d, %Y")
            else
                  @start_date = "No start date found, please contact Grapevine"
            end
            




      end

end
