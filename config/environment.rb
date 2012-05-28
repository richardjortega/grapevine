# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Grapevine::Application.initialize!

# Setup ActionMailer to work with SendGrid
ActionMailer::Base.smtp_settings = {
    :user_name => "grapevine",
    :password => "grape2011",
    :domain => "pickgrapevine.com",
    :address => "smtp.sendgrid.net",
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
