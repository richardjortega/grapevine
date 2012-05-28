class NotifyMailer < ActionMailer::Base
  #Alerts email from pickgrapevine; auto-reply nada!
  default from: "alerts@pickgrapevine.com"

  # Send a signup email to the user, pass user object that contains the user's email address
  
  ### Used for testing inside of 'rails c', can email as an argument
  # def signup(email)
  #   mail to: email, subject: "TESTy: Ohh.. me soo horny...; Thanks for signing up!"
  # end

  ### Used in production
  # Send signup email notification using SendGrid
  def signup(user)
    mail to: user.email, subject: "Thanks for signing up!"
  end

  # Send signup email notification to Erik, pass in user object
  def alert_erik(user)
    @user = user
    mail to: "erik@pickgrapevine.com", subject: "New customer signed up"
  end
end
