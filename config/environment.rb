# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Grapevine::Application.initialize!

# Configuration for using SendGrid on Heroku
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => 'grapevine',
  :password       => 'grape2011',
  :domain         => 'pickgrapevine.com',
  :enable_starttls_auto => true
}

# Load up Delayed_Rake
require_relative '../lib/delayed_rake.rb'
