class NotifyMailer < ActionMailer::Base
  #Alerts email from pickgrapevine; auto-reply to no-reply!
  default from: "alerts@pickgrapevine.com",
          reply_to: "no-reply@pickgrapevine.com"

  #Friendly amount formats
  def format_amount(amount)
    sprintf('$%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end

  #Friendly time formats
  def format_timestamp(timestamp)
    Time.at(timestamp).strftime("%m/%d/%Y")
  end

  # Send a signup email to the user, pass user object that contains the user's email address
  def free_signup(user)
    @user = user
    mail to: user.email, subject: "Thanks for signing up to Grapevine for 30 days!"
  end
  
  # Send a signup email to the user, pass user object that contains the user's email address
  def paid_signup(user)
    @user = user
    mail to: user.email, subject: "Thanks for signing up!"
  end

  # Send signup email notification to Grapevine support when we have a new customer
  def new_customer(user)
    @user = user
    mail to: "erik@pickgrapevine.com", subject: "New customer signed up"
  end

  # Email invoice receipt to User's email and Grapevine Support - successful
  # Called in HooksController
  def successfully_invoiced(invoice, user)
    @subscription = invoice.lines.subscriptions[0]
    @user = user
    @subscription_plan = @subscription.plan.name
    @subscription_amount = format_amount(invoice.total)
    @subscription_start = format_timestamp(@subscription.period.start)
    @subscription_end = format_timestamp(@subscription.period.end)
    # Mail invoice 
    mail to: user.email, subject: "Grapevine Receipt", bcc: "erik@pickgrapevine.com"
  end

  # Email invoice receipt to User's email and Grapevine Support - failed
  # Called in HooksController
  def unsuccessfully_invoiced(invoice, user)
    puts "We're still working on this..."
  end

  # 

end