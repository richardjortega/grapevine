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
          f.xAxis(:categories => ['01', '02', '03', '04', '05', '06', 
                        '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30'])
          f.series(:name => 'OpenTable', :data => [2, 6, 9, 5, 8, 1, 2, 5, 3, 8, 3, 6, 2, 4, 1, 2, 6, 9, 5, 8, 1, 2, 5, 3, 8, 3, 6, 2, 4, 1] )
          f.series(:name => 'Yelp', :data => [2, 8, 7, 1, 1, 2, 4, 1, 2, 4, 6, 5 , 5, 2, 6, 2, 8, 7, 1, 1, 2, 4, 1, 2, 4, 6, 5 , 5, 2, 6] )
    end

    @chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 50, 0, 50]} )
      series = {
               :type=> 'pie',
               :name=> 'Browser share',
               :data=> [
                  ['Firefox',   45.0],
                  ['IE',       26.8],
                  {
                     :name=> 'Chrome',    
                     :y=> 12.8,
                     :sliced=> true,
                     :selected=> true
                  },
                  ['Safari',    8.5],
                  ['Opera',     6.2],
                  ['Others',   0.7]
               ]
      }
      f.series(series)
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
      f.plot_options(:pie=>{
        :allowPointSelect=>true, 
        :cursor=>"pointer" , 
        :dataLabels=>{
          :enabled=>true,
          :color=>"black",
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
