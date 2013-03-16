class LocationsController < ApplicationController

  layout 'dashboard'
  before_filter :set_items

  # GET /locations
  # GET /locations.json
  def index
    @locations = current_user.locations

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    #@location = Location.find(params[:id])
    @item = Location.find(params[:id])

    # testing ton of locations
    # user = User.find(106)
    # @items = user.locations

    @reviews = @item.reviews

    last_two_weeks_dates = (2.weeks.ago.to_date..Date.today).map(&:day).map(&:to_s)
    @last_two_weeks_reviews = @reviews.last_two_weeks_reviews
    


    @this_month_reviews = @reviews.this_month_reviews
    @last_month_reviews = @reviews.last_month_reviews



    @line_chart = LazyHighCharts::HighChart.new('graph') do |f|
          f.options[:chart][:defaultSeriesType] = 'line'
          f.legend(:layout=> 'horizontal') 
          f.xAxis(:categories => ['01', '02', '03', '04', '05', '06', 
                        '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30'])
          f.series(:name => 'UrbanSpoon', :color => '#000099', :data => [0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, ] )
          f.series(:name => 'Yelp', :color => '#cc0000', :data => [0, 1, 3, 0, 1, 0, 0, 0, 3, 1, 0, 0, 2, 0, 3, 1, 0, 0, 1, 1, 2, 0, 1, 0, 0, 0, 0, 1, 0, 0] )
          f.series(:name => 'TripAdvisor', :color => '#009900', :data => [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0] )
          f.series(:name => 'Google+', :color => '#0066ff', :data => [0, 0, 0, 0, 1, 0, 2, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0] )
          #f.series(:name => 'OpenTable', :color => '#cccc99', :data => [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ] )
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

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

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

  def set_items
     @items = current_user.locations
  end
end
