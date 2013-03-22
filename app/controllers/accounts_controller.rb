class AccountsController < ApplicationController
      force_ssl
      layout 'dashboard'
      before_filter :set_items

      def dashboard

            # testing ton of locations
            # user = User.find(106)
            # @items = user.locations

            @items = current_user.locations

                # testing ton of locations
                # user = User.find(106)
                # @items = user.locations

                @reviews = @items.first.reviews

                @last_two_weeks_dates = (2.weeks.ago.to_date..Date.today).map(&:day).map(&:to_s)
                @last_two_weeks_reviews = @reviews.last_two_weeks_reviews

                


                @this_month_reviews = @reviews.this_month_reviews
                @last_month_reviews = @reviews.last_month_reviews

            @line_chart = LazyHighCharts::HighChart.new('graph') do |f|
                  f.options[:chart][:defaultSeriesType] = 'line'
                  f.title(:text => 'Number of Reviews')
                  f.xAxis(:categories => ['01', '02', '03', '04', '05', '06', 
                        '07', '08', '09', '10', '11', '12', '13', '14', '15'])
                  f.series(:name => 'OpenTable', :data => [2, 6, 9, 5, 8, 1, 2, 5, 3, 8, 3, 6, 2, 4, 1] )
                  f.series(:name => 'Yelp', :data => [2, 8, 7, 1, 1, 2, 4, 1, 2, 4, 6, 5 , 5, 2, 6] )
            end

            @chart = LazyHighCharts::HighChart.new('pie') do |f|
                  f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 0, 0, 0]} )
                  f.colors(['#000099', '#cc0000', '#009900', '#0066ff', '#cccc99'])
                  series = {
                           :type=> 'pie',
                           :name=> 'Browser share',
                           :data=> [
                              ['UrbanSpoon',   7],
                              ['Yelp',       19],
                              ['TripAdvisor',    5],
                              ['Google+',     9],
                              ['OpenTable',   0]
                           ]
                  }
                  f.series(series)
                  f.legend(:layout=> 'horizontal',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
                  f.plot_options(:pie=>{
                    :allowPointSelect=>true, 
                    :cursor=>"pointer" , 
                    :dataLabels=>{
                      :enabled=>false,
                      },
                      :showInLegend=>true
                  })
            end


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

      def pro_features
      end

private

      def set_items
            @items = current_user.locations
      end
end