source 'https://rubygems.org'

# Additions for AppFog
gem 'cloudfoundry-jquery-rails'
gem 'cloudfoundry-devise', :require => 'devise'

# Main
gem 'rails', '3.2.8'
gem 'thin'
gem 'jquery-rails'
gem 'geocoder'
gem 'seedbank'

# Front-end
gem 'client_side_validations', '3.2.0'

# Payment
gem 'stripe'
gem 'stripe_event'

# Auth/Auth
gem 'devise'
gem 'cancan', '>= 1.6.7'
gem 'rolify', '>= 3.1.0'

# Some crawling madness
gem 'nokogiri'
gem 'watir-webdriver'
gem 'headless'

# Mailers
gem 'mailchimp'
gem 'roadie'

# Background Processes/Workers
gem 'iron_worker_ng'
gem 'poltergeist'

# Gems for the Vineyard
gem 'oauth'
gem 'httparty'
gem 'rest-client'

# Design
gem 'bootstrap-sass', '2.0.3'
gem 'meta-tags', :require => 'meta_tags'

#used only in testing, but heroku needs all rake to pass before using other rakes
#needs to be configured correctly laterhero
gem 'database_cleaner', '>= 0.7.2'

group :production do
	# gem 'mysql2'
	gem 'newrelic_rpm'
	gem 'pg'
end


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development do
	gem 'foreman'
	gem 'sqlite3'
	gem 'rspec-rails'
	gem 'guard-rspec'
	gem 'rb-fsevent', :require => false
	gem 'growl'
	gem 'ruby_gntp'
	gem 'guard-spork'
	gem 'factory_girl_rails', '>= 3.1.0'
	gem 'debugger'
	gem 'rails-erd'
	gem 'thoughtbot-shoulda'
	gem 'awesome_print'
end

group :test do
	gem 'email_spec'
	gem 'capybara'
	gem 'launchy'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
