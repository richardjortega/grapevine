source 'https://rubygems.org'

gem 'rails', '3.2.5'
gem 'bootstrap-sass', '2.0.3'
gem 'stripe'
gem 'stripe_event'
gem 'thin'

gem 'jquery-rails'
gem 'mailchimp'
gem 'roadie'
gem 'devise', '>= 2.1.0.rc'
gem 'cancan', '>= 1.6.7'
gem 'rolify', '>= 3.1.0'

group :production do
	# gem 'mysql2'
	gem 'pg'
	gem 'newrelic_rpm'
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
	gem 'database_cleaner', '>= 0.7.2'
	gem 'launchy'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
