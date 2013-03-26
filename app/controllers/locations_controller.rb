class LocationsController < ApplicationController

  layout 'dashboard'
  before_filter :set_items

  # for time being, index and edit actions have been disabled.

  # GET /locations
  # GET /locations.json
  # def index
  #   @locations = current_user.locations

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @locations }
  #   end
  # end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @item = Location.find(params[:id])
    @sources = Source.all
    @reviews = @item.reviews

    @last_two_weeks_reviews = @reviews.last_two_weeks_reviews
    @this_month_reviews = @reviews.this_month_reviews
    @last_month_reviews = @reviews.last_month_reviews

    ### Pie Chat Data for all time views, Needs major refactoring ###
    @last_two_weeks_reviews_pie_chart_data = []
    @sources.each do |source|
      data_set = []
      source_name = source.name.capitalize
      total_reviews = @last_two_weeks_reviews.where("source_id = ?", source.id).count
      data_set << source_name
      data_set << total_reviews
      @last_two_weeks_reviews_pie_chart_data << data_set
    end

    @this_month_reviews_pie_chart_data = []
    @sources.each do |source|
      data_set = []
      source_name = source.name.capitalize
      total_reviews = @this_month_reviews.where("source_id = ?", source.id).count
      data_set << source_name
      data_set << total_reviews
      @this_month_reviews_pie_chart_data << data_set
    end

    @last_month_reviews_pie_chart_data = []
    @sources.each do |source|
      data_set = []
      source_name = source.name.capitalize
      total_reviews = @last_month_reviews.where("source_id = ?", source.id).count
      data_set << source_name
      data_set << total_reviews
      @last_month_reviews_pie_chart_data << data_set
    end

    #### CHARTS FOR LAST TWO WEEKS REVIEWS #####

    @last_two_weeks_reviews_line_chart = LazyHighCharts::HighChart.new('graph') do |f|
          f.options[:chart][:defaultSeriesType] = 'line'
          f.legend(:layout=> 'horizontal') 
          f.xAxis(:type => 'datetime')
          @sources.each do |source|
            f.series(:pointInterval => 1.day, :pointStart => 2.weeks.ago.to_date, :name => source.name.capitalize, :color => source.hex_value, :data => locations_chart_data(2.weeks.ago.to_date..Date.today, source).map(&:values).flatten.map {|value|value.to_i} )
          end
    end

    @last_two_weeks_reviews_pie_chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 0, 0, 0]} )
      f.colors(@sources.map(&:hex_value))
      series = {
               :type=> 'pie',
               :data=> @last_two_weeks_reviews_pie_chart_data
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
    ##########


    #### CHARTS FOR THIS MONTH REVIEWS #####

    @this_month_reviews_line_chart = LazyHighCharts::HighChart.new('graph') do |f|
          f.options[:chart][:defaultSeriesType] = 'line'
          f.legend(:layout=> 'horizontal') 
          f.xAxis(:type => 'datetime')
          @sources.each do |source|
            f.series(:pointInterval => 1.day, :pointStart => Date.today.beginning_of_month, :name => source.name.capitalize, :color => source.hex_value, :data => locations_chart_data(Date.today.beginning_of_month..Date.today, source).map(&:values).flatten.map {|value|value.to_i} )
          end
    end

    @this_month_reviews_pie_chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 0, 0, 0]} )
      f.colors(@sources.map(&:hex_value))
      series = {
               :type=> 'pie',
               :data=> @this_month_reviews_pie_chart_data
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
    ##########

    #### CHARTS FOR LAST MONTH REVIEWS #####

    @last_month_reviews_line_chart = LazyHighCharts::HighChart.new('graph') do |f|
          f.options[:chart][:defaultSeriesType] = 'line'
          f.legend(:layout=> 'horizontal') 
          f.xAxis(:type => 'datetime')
          @sources.each do |source|
            f.series(:pointInterval => 1.day, :pointStart => Date.today.prev_month.beginning_of_month, :name => source.name.capitalize, :color => source.hex_value, :data => locations_chart_data(Date.today.prev_month.beginning_of_month..Date.today, source).map(&:values).flatten.map {|value|value.to_i} )
          end
    end

    @last_month_reviews_pie_chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 0, 0, 0]} )
      f.colors(@sources.map(&:hex_value))
      series = {
               :type=> 'pie',
               :data=> @last_month_reviews_pie_chart_data
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
    ##########

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # # GET /locations/1/edit
  # def edit
  #   @location = Location.find(params[:id])
  # end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

private

  def set_items
     @items = current_user.locations
     @plan = current_user.subscription.plan
  end

  def locations_chart_data(date_range, source)
    # @reviews instance variable set in the SHOW action
    reviews_by_day = @reviews.where("source_id = ?", source.id).group("date(post_date)").select("post_date, count(id) as total_reviews").each_with_object({}) { |o,hsh| hsh[o.post_date.to_date] = o.total_reviews }

    #group_by { |l| l.post_date.to_date }

    (date_range).map do |date|
      {
        reviews: reviews_by_day[date] || 0
      }
    end
  end

end
