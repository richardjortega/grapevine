class AccountsController < ApplicationController
      force_ssl

      # caches_action :index, :layout => false
      # caches_action :show, :layout => false
      # caches_action :billing, :layout => false

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

      def update
            @user = current_user
            @plans = Plan.all
            @plan_identifier = @user.plan.identifier

            if @user.plan.location_limit.nil?
                  @location_limit = '1'
            else 
                  @location_limit = @user.plan.location_limit
            end

            if @user.plan.review_limit.nil?
                  @review_limit = 'Unlimited'
            else
                  @review_limit = @user.plan.review_limit
            end

            @location = @user.locations[0]
            @subscription = @user.subscription

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

      def billing
            @user = current_user
            @subscription = @user.subscription
      end

end
