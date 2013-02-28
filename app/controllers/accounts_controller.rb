class AccountsController < ApplicationController
      force_ssl
      layout 'dashboard'

      def dashboard
            
            # testing ton of locations
            # user = User.find(106)
            # @items = user.locations

            @items = current_user.locations
            @item = @items.first
            @reviews = @item.reviews

            @line_chart = LazyHighCharts::HighChart.new('graph') do |f|
                  f.options[:chart][:defaultSeriesType] = 'line'
                  f.title(:text => 'Testing line graph')
                  f.xAxis(:categories => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])
                  f.series(:name => 'Tokyo', :data => [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6] )
                  f.series(:name => 'New York', :data => [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5] )
            end

            @pie_chart = LazyHighCharts::HighChart.new('pie') do |f|
                  f.chart({:defaultSeriesType => 'pie'})
                  series = {
                        :type => 'pie',
                        :name => 'Browser share',
                        :data => [
                              ['TripAdvisor', 22],
                              ['Yelp', 28],
                              ['OpenTable', 50]
                        ]
                  }
                  f.series(series)
                  f.title(:text => 'Suck it')
                  f.legend(:layout => 'veritcal', :style => {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
                  f.plot_options(:pie=>{
                    :allowPointSelect=>true, 
                    :cursor=>"pointer" , 
                    :dataLabels=>{
                      :enabled=>true,
                      :color=>"white",
                      :connectorColor=>'black',
                      :style=>{
                        :font=>"13px Trebuchet MS, Verdana, sans-serif"
                      }
                    }
                  })
            end
      end

	def index

            if current_user.plan.identifier == 'gv_needs_to_pay'
                  redirect_to upgrade_path
            end

            DelayedKiss.alias(current_user.full_name, current_user.email) unless current_user.nil?
            DelayedKiss.record(current_user.email, 'Signed In') unless current_user.nil?

            @locations = current_user.locations

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
