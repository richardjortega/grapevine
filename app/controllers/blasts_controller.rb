
class BlastsController < ApplicationController

  # GET /blasts/1
  def show
    @blast = Blast.find_by_marketing_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def wantmore2
  	@blast = Blast.find_by_marketing_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def wantmore3
  	@blast = Blast.find_by_marketing_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def wantmore4
  	@blast = Blast.find_by_marketing_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
end