class StaticPagesController < ApplicationController
 
  def home
  end

  def about
  end

  def signup
  	@user			      = User.new
  	@plan 			    = Plan.find_by_identifier('gv_free')
  	@location       = @user.locations.build
  	@subscription 	= Subscription.new
  end

  def pricing
  end

  def learn_more
  end

  def contact
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

  def send_follow_up
  end

  def terms
  end

  def privacy
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

  def follow_up_alert
    email = params[:email]
    name = params[:name]
    body = params[:body]
    body_part2 = params[:body_part2]
    location_link = params[:location_link]

    NotifyMailer.follow_up_alert(email, name, body, body_part2, location_link).deliver

    redirect_to send_follow_up_path, :notice => "Your follow-up email has been sent successfully to: #{email}"

  end

  def submit_contact_us
    email = params[:email] || 'No email provided'
    name = params[:name] || 'No name provided'
    body = params[:body] || 'No body provided'
    subject = params[:subject] || 'No subject provided'
    phone_number = params[:phone_number] || 'No phone number provided'

    NotifyMailer.submit_contact_us(email, name, body, subject, phone_number).deliver

    redirect_to contact_path, :notice => "Thank you for contacting us we'll respond to you as soon as possible."

  end

end
