class StaticPagesController < ApplicationController
 
  def home
  end

  def signup
  	@user			      = User.new
  	@plan 			    = Plan.find_by_identifier("basic_monthly")
  	@location       = @user.locations.build
  	@subscription 	= Subscription.new
  end

  def concierge
  end

  def thankyou
  end

  def signup2
  end

  def error404
  end

  def thor_of_asgard
  end

  def review_alert params
    pp params
    debugger
  end

end
