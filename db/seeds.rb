require 'database_cleaner'
  # whipe a hoe db!
  DatabaseCleaner.strategy = :truncation
  # then, whenever you need to clean the DB
  DatabaseCleaner.clean

# Add intital user
# puts "Setting up default user login"
# user1 = User.create! :first_name => "Erik", :last_name => "Larson", :email => "erik@pickgrapevine.com", :password => 'please', :password_confirmation => 'please'
# puts "New user created: #{user1.first_name} #{user1.last_name}"


# Seed stripe plans
# Stripe can give an Stripe::InvalidRequestError: Plan already exists. If that occurs, simply move on
stripe_plans = [
  { amount: 3000, interval: 'month', currency: 'usd', id: 'basic_monthly', name: 'Grapevine Alerts - Basic Monthly',  trial_period_days: '30' },
  { amount: 30000, interval: 'year', currency: 'usd', id: 'basic_yearly',  name: 'Grapevine Alerts - Basic Yearly'}
]

# If a plan is already created inside of Stripe, it will return an error.
stripe_plans.each { |plan| Stripe::Plan.create plan rescue puts "Skipping #{ plan[:name] } - Already in Stripe Plans"}

# Seed Plans table, matches what we have in Stripe
basic_monthly = stripe_plans[0]
basic_yearly = stripe_plans[1]
Plan.create! :name => basic_monthly[:name], :amount => basic_monthly[:amount], :identifier => basic_monthly[:id], :currency => basic_monthly[:currency], :interval => basic_monthly[:interval], :trial_period_days => basic_monthly[:trial_period_days]
puts "Created #{basic_monthly[:name]} in local database"
Plan.create! :name => basic_yearly[:name], :amount => basic_yearly[:amount], :identifier => basic_yearly[:id], :currency => basic_yearly[:currency], :interval => basic_yearly[:interval]
puts "Created #{basic_yearly[:name]} in local database"
