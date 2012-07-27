class StaticPagesController < ApplicationController
 
  def home
  end

  def signup
  	@plan 			= Plan.find_by_identifier("basic_monthly")
  	@subscription 	= Subscription.new
  end

private

end
