source 'https://rubygems.org'

gem 'rails', '3.2.5'
gem 'bootstrap-sass', '2.0.3'
gem 'stripe',	'~> 1.7.0'
gem 'formtastic', '~> 2.1.1'
gem 'formtastic-bootstrap'
#gem 'bcrypt-ruby', :require => 'bcrypt'

group :production do
	gem 'pg'
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development, :test do
	gem 'sqlite3'
	gem 'rspec-rails'
	gem 'guard-rspec'
	gem 'rb-fsevent', :require => false
	gem 'growl'
	gem 'ruby_gntp'
	gem 'guard-spork'
	gem 'factory_girl_rails', '>= 3.1.0'
end

group :test do
	gem 'email_spec'
	gem 'capybara'
	gem 'database_cleaner', '>= 0.7.2'
	gem 'launchy'
	gem 'shoulda-matchers'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'
end

gem 'jquery-rails'
gem 'roadie'
gem 'devise', '>= 2.1.0.rc'
gem 'cancan', '>= 1.6.7'
gem 'rolify', '>= 3.1.0'

# Monitoring apps
gem 'newrelic_rpm'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
