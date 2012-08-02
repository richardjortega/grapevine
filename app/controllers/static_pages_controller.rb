class StaticPagesController < ApplicationController
 
  def home
  end

  def signup
  	@user			      = User.new
  	@plan 			    = Plan.find_by_identifier("basic_monthly")
  	@locations      = @user.locations.build
  	@subscription 	= Subscription.new
  end

  def concierge
  end

  def thankyou
  end

end
