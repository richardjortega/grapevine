class StaticPagesController < ApplicationController

  def home
  end

  def about
  end

  def signup
    if request.fullpath.include?('signup-now')
        @plan = Plan.find_by_identifier('gv_needs_to_pay')
      elsif request.fullpath.include?('agency-signup')
        @plan = Plan.find_by_identifier('gv_agency')
      else
        @plan = Plan.find_by_identifier('gv_free')
    end
  	@user			      = User.new
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

  def thank_you
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



  def send_to_site
    if params[:kme] == 'Clicked Read Full Review'
      DelayedKiss.record(params[:kmi], 'Clicked Read Full Review', {'Source' => "#{params[:source]}", 
                                      'Plan_Type' => "#{params[:km_plan_type]}", 'Link' => "#{params[:link]}" }) 
    else params[:kme] == 'Clicked Respond to Review'
      DelayedKiss.record(params[:kmi], 'Clicked Respond to Review', {'Source' => "#{params[:source]}", 
                                      'Plan_Type' => "#{params[:km_plan_type]}", 'Link' => "#{params[:link]}" }) 
    end
    redirect_to params[:link]
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
    NotifyMailer.delay.review_alert(email, review, rating, source, location, location_link)

    # Ensure Erik knows shit was sent
    redirect_to thor_of_asgard_path, :notice => "Your review alert has been sent successfully to: #{email}"
  end

  def follow_up_alert
    email = params[:email]
    name = params[:name]
    body = params[:body]
    body_part2 = params[:body_part2]
    location_link = params[:location_link]

    NotifyMailer.delay.follow_up_alert(email, name, body, body_part2, location_link)

    redirect_to send_follow_up_path, :notice => "Your follow-up email has been sent successfully to: #{email}"

  end

  def submit_contact_us
    email = params[:email]
    name = params[:name]
    body = params[:body]
    subject = params[:subject]
    phone_number = params[:phone_number]

    NotifyMailer.delay.submit_contact_us(email, name, body, subject, phone_number)

    redirect_to contact_path, :notice => "Thank you for contacting us we'll respond to you as soon as possible."

  end

end
