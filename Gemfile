source 'https://rubygems.org'

# Main
gem 'rails', '3.2.11'
gem 'thin'
gem 'jquery-rails'
gem 'geocoder'
gem 'seedbank'
gem 'activeadmin'
gem 'meta_search',	'>= 1.1.0.pre'
gem 'dalli'

# Front-end
gem 'client_side_validations', '3.2.0'
gem 'meta-tags', :require => 'meta_tags'

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

# Mailers
gem 'mailchimp'
gem 'roadie'

# Background Processes/Workers
gem 'iron_worker_ng'
gem 'delayed_job_active_record'
gem 'dj_mon'

# Gems for the Vineyard
gem 'oauth'
gem 'httparty'

#used only in testing, but heroku needs all rake to pass before using other rakes

group :production do
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
	gem 'database_cleaner', '>= 0.7.2'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
