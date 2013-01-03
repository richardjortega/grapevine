class NotifyMailer < ActionMailer::Base
  #Alerts email from pickgrapevine; auto-reply to no-reply!
  default from: "alerts@pickgrapevine.com",
          reply_to: "info@pickgrapevine.com",
          bcc: "alerts+logs@pickgrapevine.com"

  # All agruements accept strings
  def review_alert(email, review, rating, source, location, location_link)
    @email = email
    @review = review
    @rating = rating
    @source = source
    @location = location
    @location_link = location_link
    
    if source == 'yelp'
        @source = "Yelp"
        @logo = "http://www.pickgrapevine.com/assets/email/yelp_logo_small.png"
        @response_link = "http://biz.yelp.com"
      elsif source == 'opentable'
        @source = "Opentable"
        @logo = "http://www.pickgrapevine.com/assets/email/open-table-logo_small.png"
        @response_link = "http://www.otrestaurant.com"
      elsif source == 'google'
        @source = "Google Places"
        @logo = "http://www.pickgrapevine.com/assets/pics/Google-Places.jpg"
        @response_link = "http://www.google.com/placesforbusiness"
      elsif source == 'tripadvisor'
        @source = "Tripadvisor"
        @logo = "http://www.pickgrapevine.com/assets/email/tripadvisor_logo_small.png"
        @response_link = "http://www.tripadvisor.com/Owners"
      elsif source == 'urbanspoon'
        @source = "Urbanspoon"
        @logo = "http://www.pickgrapevine.com/assets/email/urbanspoon_logo_small.png"
        @response_link = "http://www.urbanspoon.com/u/signin"

      else
        return false
    end
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

  def submit_contact_us(email, name, body, subject)
    @email = email
    @name = name
    @body = body
    @subject = subject

    mail to: 'info@pickgrapevine.com', subject: "Contact form submitted", from: "#{email}", reply_to: 
    "#{email}"

  end


  # Send a signup email to the user, pass user object that contains the user's email address
  def free_signup(user)
    @user = user
    add_user_to_marketing_list(user)
    mail to: user.email, subject: "Thanks for signing up to Grapevine's Free Forever plan!"
  end
  
  # Send a signup email to the user, pass user object that contains the user's email address
  def paid_signup(user)
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
    mail to: user.email, subject: "Unsuccessful Payment - Grapevine Receipt", bcc: "erik@pickgrapevine.com"
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
    mail to: user.email, subject: "Grapevine Payment Receipt", bcc: "erik@pickgrapevine.com"
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
