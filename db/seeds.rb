

# Add intital user
# puts "Setting up default user login"
# user1 = User.create! :first_name => "Erik", :last_name => "Larson", :email => "erik@pickgrapevine.com", :password => 'please', :password_confirmation => 'please'
# puts "New user created: #{user1.first_name} #{user1.last_name}"


# Seed stripe plans
# Stripe can give an Stripe::InvalidRequestError: Plan already exists. If that occurs, simply move on
stripe_plans = [
  { amount: 0, interval: 'month', currency: 'usd', id: 'gv_free',  name: 'Grapevine Alerts - Free Forever Plan'},
  { amount: 3000, interval: 'month', currency: 'usd', id: 'gv_30',  name: 'Grapevine Alerts - Basic Monthly Plan (1 Location)'},
  { amount: 5000, interval: 'month', currency: 'usd', id: 'gv_50',  name: 'Grapevine Alerts - Basic Monthly Plan (3 Locations)'}
]

# If a plan is already created inside of Stripe, it will return an error.
stripe_plans.each { |plan| Stripe::Plan.create plan rescue puts "Skipping #{ plan[:name] } - Already in Stripe Plans"}

# Seed Plans table, matches what we have in Stripe
gv_free = stripe_plans[0]
gv_30 = stripe_plans[1]
gv_50 = stripe_plans[2]
Plan.find_or_create_by_identifier! :identifier => gv_free[:id], :name => gv_free[:name], :amount => gv_free[:amount], :currency => gv_free[:currency], :interval => gv_free[:interval], :trial_period_days => gv_free[:trial_period_days]
puts "Created #{gv_free[:name]} in local database"
Plan.find_or_create_by_identifier! :identifier => gv_30[:id], :name => gv_30[:name], :amount => gv_30[:amount], :currency => gv_30[:currency], :interval => gv_30[:interval]
puts "Created #{gv_30[:name]} in local database"
Plan.find_or_create_by_identifier! :identifier => gv_50[:id], :name => gv_50[:name], :amount => gv_50[:amount], :currency => gv_50[:currency], :interval => gv_50[:interval]
puts "Created #{gv_50[:name]} in local database"