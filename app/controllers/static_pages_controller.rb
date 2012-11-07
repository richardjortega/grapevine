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

  def review_alert

    # Associate all params to appropiate 
    email = params[:email]
    review = params[:review]
    rating = params[:rating]
    source = params[:source]
    location = params[:location]
    location_link = params[:location_link]

    # Send review alert to a person (BCC sent to alerts+logs@pickgrapevine.com)
    NotifyMailer.review_alert(email, review, rating, source, location, location_link).deliver

    # Ensure Erik knows shit was sent
    redirect_to thor_of_asgard_path, :notice => "Your review alert has been sent successfully to: #{email}"
  end

end
