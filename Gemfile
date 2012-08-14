source 'https://rubygems.org'

# Main
gem 'rails', '3.2.5'
gem 'thin'
gem 'jquery-rails'

# Payment
gem 'stripe'
gem 'stripe_event'

# Auth/Auth
gem 'devise', '>= 2.1.0.rc'
gem 'cancan', '>= 1.6.7'
gem 'rolify', '>= 3.1.0'

# Mailers
gem 'mailchimp'
gem 'roadie'

# Design
gem 'bootstrap-sass', '2.0.3'
gem 'meta-tags', :require => 'meta_tags'

# Forms
gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'

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
group :development, :test do
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
