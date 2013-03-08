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
