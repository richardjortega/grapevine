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

# Exception/Error Reporting
gem 'airbrake'
gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"

# Analytics
gem 'keen'
gem 'lascivious'
gem 'delayed_kiss'

# SEO
gem 'roboto'
gem 'sitemap_generator'

# Front-end
gem 'client_side_validations'
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
gem 'database_cleaner', '>= 0.7.2'

group :production do
	gem 'newrelic_rpm'
	gem 'pg'
end


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development do
	gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
	gem 'letter_opener'
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
