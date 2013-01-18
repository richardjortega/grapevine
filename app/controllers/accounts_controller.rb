class AccountsController < ApplicationController
      force_ssl

	def index
            DelayedKiss.alias(current_user.full_name, current_user.email) unless current_user.nil?
            DelayedKiss.record(current_user.email, 'Signed In') unless current_user.nil?

            @plan = current_user.subscription.plan
            @location = current_user.locations[0]
            @subscription = current_user.subscription

            # For aside

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
            @location = @user.locations[0]
            @subscription = @user.subscription

            if request.fullpath.include?('upgrade')
                  DelayedKiss.record(@user.email, 'Free User Viewed Upgrade Page')
            end

            if request.fullpath.include?('changeplan')
                  DelayedKiss.record(@user.email, 'Paid User Viewed Change Plan Page')
            end

            # For aside content
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
            @plans = Plan.all
            @plan_identifier = @user.plan.identifier
            @location = @user.locations[0]
            @subscription = @user.subscription

            # For aside content
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

      def upgrade_thank_you
      end

end
