class NotifyMailer < ActionMailer::Base
  #Alerts email from pickgrapevine; auto-reply to no-reply!
  default from: "alerts@pickgrapevine.com",
          reply_to: "info@pickgrapevine.com",
          bcc: "alerts+logs@pickgrapevine.com"

  # All agruements accept strings
  def review_alert(email, review, rating, source, location, location_link, review_count, plan_type)
    @email = email
    @review = review
    @rating = rating
    @source = source
    @location = location
    @plan_type = plan_type
    @review_count = review_count

    # needs to change to normal production path once setup
    host = 'www.pickgrapevine.com'
    q_full_review = URI.encode_www_form('link' => location_link, 'kme' => 'Clicked Read Full Review', 'kmi' => email, 'km_plan_type' => plan_type, 'source' => "#{source.to_s.titleize}")
    @location_link = "http://#{host}/send_to_site?#{q_full_review}"

    if plan_type == 'free'
      case @review_count
        when 1
          @review_message = 'Your first review this month'
          @review_progress_bar = '4-remaining.png'
        when 2
          @review_message = 'Thats 2 two reviews so far.'
          @review_progress_bar = '3-remaining.jpg'
        when 3
          @review_message = 'You have 2 reviews left.'
          @review_progress_bar = '2-remaining.jpg'
        when 4
          @review_message = 'Oh, snap. You have 1 review remaining.'
          @review_progress_bar = '1-remaining.jpg'
        when 5
          @review_message = 'You have reached your limit.'
          @review_progress_bar = '0-remaining.jpg'
      end
    end
    
    if source == 'yelp'
        @source = "Yelp"
        @logo = "http://www.pickgrapevine.com/assets/email/yelp-clear.png"
        respond_link = "http://biz.yelp.com"
        q_respond = URI.encode_www_form('link' => respond_link, 'kme' => 'Clicked Respond to Review', 'kmi' => email, 'km_plan_type' => plan_type, 'source' => "#{source.to_s.titleize}")
        @response_link = "http://#{host}/send_to_site?#{q_respond}"
      
      elsif source == 'opentable'
        @source = "Opentable"
        @logo = "http://www.pickgrapevine.com/assets/email/opentable-clear.png"
        respond_link = "http://www.otrestaurant.com"
        q_respond = URI.encode_www_form('link' => respond_link, 'kme' => 'Clicked Respond to Review', 'kmi' => email, 'km_plan_type' => plan_type, 'source' => "#{source.to_s.titleize}")
        @response_link = "http://#{host}/send_to_site?#{q_respond}"
      
      elsif source == 'google'
        @source = "Google Places"
        @logo = "http://www.pickgrapevine.com/assets/pics/google-clear.png"
        respond_link = "http://www.google.com/placesforbusiness"
        q_respond = URI.encode_www_form('link' => respond_link, 'kme' => 'Clicked Respond to Review', 'kmi' => email, 'km_plan_type' => plan_type, 'source' => "#{source.to_s.titleize}")
        @response_link = "http://#{host}/send_to_site?#{q_respond}"
      
      elsif source == 'tripadvisor'
        @source = "Tripadvisor"
        @logo = "http://www.pickgrapevine.com/assets/email/tripadvisor-clear.png"
        respond_link = "http://www.tripadvisor.com/Owners"
        q_respond = URI.encode_www_form('link' => respond_link, 'kme' => 'Clicked Respond to Review', 'kmi' => email, 'km_plan_type' => plan_type, 'source' => "#{source.to_s.titleize}")
        @response_link = "http://#{host}/send_to_site?#{q_respond}"
      
      elsif source == 'urbanspoon'
        @source = "Urbanspoon"
        @logo = "http://www.pickgrapevine.com/assets/email/urbanspoon-clear.png"
        respond_link = "http://www.urbanspoon.com/u/signin"
        q_respond = URI.encode_www_form('link' => respond_link, 'kme' => 'Clicked Respond to Review', 'kmi' => email, 'km_plan_type' => plan_type, 'source' => "#{source.to_s.titleize}")
        @response_link = "http://#{host}/send_to_site?#{q_respond}"

      else
        return false
    end
    ### Track all review alerts sent
    DelayedKiss.record(email, 'Sent Review Alert', {'Location' => "#{location}", 
                                                      'Source' => "#{source.to_s.titleize}" })
    puts "GV Review Alert: Sent a #{source.capitalize} review alert to #{location} to #{email}"
    mail to: @email, subject: "You have a new #{source.to_s.titleize} review"
  end

  # Follow up email for people after calling

  def follow_up_alert(email, name, body, body_part2, location_link)
    @name = name  
    @body = body
    @body_part2 = body_part2
    @location_link = location_link

    mail to: email, subject: "Follow-up info from Grapevine", from: "erik@pickgrapevine.com", reply_to: 
    "erik@pickgrapevine.com"

  end

  def submit_contact_us(email, name, body, subject, phone_number)
    @email = email
    @name = name
    @body = body
    @subject = subject
    @phone_number = phone_number

    mail to: 'info@pickgrapevine.com', subject: "Contact form submitted", from: "#{email}", reply_to: 
    "#{email}"

  end


  # Send a signup email to the user, pass user object that contains the user's email address
  def free_signup(user)
    @user = user
    add_user_to_marketing_list(user)
    DelayedKiss.alias(user.full_name, user.email)
    DelayedKiss.record(user.email, 'Sent Free Signup Email')
    DelayedKiss.record(user.email, 'Subscribed to Newsletter', {'Newsletter Name' => "GV Free 5 Alerts Plan List"})
    mail to: user.email, subject: "Thanks for signing up to Grapevine's Free Forever plan!"
  end
  
  # Send a signup email to the user, pass user object that contains the user's email address
  def paid_signup(user)
    DelayedKiss.alias(user.full_name, user.email)
    DelayedKiss.record(user.email, 'Sent Paid Signup Email')
    @user = user
    mail to: user.email, subject: "You've Upgraded to our Small Business plan!"
  end

  # Update Grapevine team about important account changes
  def update_grapevine_team(user, message)
    @user = user
    @message = message
    mail to: "erik@pickgrapevine.com", subject: "Update Alert: #{@message}"
  end

  # Send canceled email
  def account_canceled(user)
    DelayedKiss.alias(user.full_name, user.email)
    DelayedKiss.record(user.email, 'Canceled')
    mail to: user.email, subject: "We're sorry to see you go!"
  end

  # Send a notice 3 days before trial ends
  def trial_ending(user)
    mail to: user.email, subject: "Only 72 Hours Left of Review Alerts!"
  end

  # Send a notice on trial expiration
  def account_expired(user) 
    mail to: user.email, subject: "Sorry to see you go the way of the Dodo..."
  end

  ### Stripe related emails (billing, charges, etc)

  # Email invoice receipt to User's email and Grapevine Support - successful
  def unsuccessfully_charged(invoice, user)
    @subscription = invoice.lines.subscriptions[0]
    @user = user
    @subscription_plan = @subscription.plan.name
    @subscription_amount = format_amount(invoice.total)
    
    # Mail invoice 
    mail to: user.email, subject: "Unsuccessful Payment - Grapevine Receipt"
  end
  
  # Email invoice receipt to User's email and Grapevine Support - failed
  def successfully_charged(invoice, user)
    @subscription = invoice.lines.subscriptions[0]
    @user = user
    @subscription_plan = @subscription.plan.name
    @subscription_amount = format_amount(invoice.total)
    @subscription_start = format_timestamp(@subscription.period.start)
    @subscription_end = format_timestamp(@subscription.period.end)
    # Mail invoice 
    mail to: user.email, subject: "Grapevine Payment Receipt"
  end
 
private
 
  #Friendly amount formats
  def format_amount(amount)
    sprintf('$%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end

  #Friendly time formats
  def format_timestamp(timestamp)
    Time.at(timestamp).strftime("%m/%d/%Y")
  end

  #Add new signup to Mailchimp list "Free Trial Signup"
  def add_user_to_marketing_list(user)
    gv_free_5_alerts_plan_list = 'a8c9d4b3b1'
    location = user.locations.last
    
    merge_vars = {
      'FNAME' => user.first_name,
      'LNAME' => user.last_name,
      'PHONE' => user.phone_number,
      'COMPANY' => location.name,
      'WEBSITE' => location.website,
      'ADDRESS' => [:addr1 => location.street_address, 
                   :addr2 => location.address_line_2, 
                   :city => location.city, 
                   :zip => location.zip ]
    }
    double_optin = false
    response = Mailchimp::API.listSubscribe({:id => gv_free_5_alerts_plan_list,
      :email_address => user.email, :merge_vars => merge_vars,
      :double_optin => double_optin})
  rescue => e
    puts "Error from Mailchimp"
    puts e.message
  end

end
