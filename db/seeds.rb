# Common seed data

# Seed stripe plans
# Stripe can give an Stripe::InvalidRequestError: Plan already exists. If that occurs, simply move on
stripe_plans = [
  { amount: 0, interval: 'month', currency: 'usd', id: 'gv_free',  name: 'Grapevine Alerts - Free Forever Plan'},
  { amount: 3000, interval: 'month', currency: 'usd', id: 'gv_30',  name: 'Grapevine Alerts - Business Pro Plan'},
  { amount: 5000, interval: 'month', currency: 'usd', id: 'gv_50',  name: 'Grapevine Alerts - Business Pro Plan'},
  { amount: 0, interval: 'month', currency: 'usd', id: 'gv_agency',  name: 'Grapevine Alerts - Agency'},
  { amount: 0, interval: 'month', currency: 'usd', id: 'gv_needs_to_pay',  name: 'Grapevine Alerts - Pro Plan'}

]

# If a plan is already created inside of Stripe, it will return an error.
stripe_plans.each { |plan| Stripe::Plan.create plan rescue puts "Skipping #{ plan[:name] } - Already in Stripe Plans"}

# Seed Plans table, matches what we have in Stripe
gv_free = stripe_plans[0]
gv_30 = stripe_plans[1]
gv_50 = stripe_plans[2]
gv_agency = stripe_plans[3]
gv_needs_to_pay = stripe_plans[4]

Plan.find_or_create_by_identifier! :identifier => gv_free[:id], :name => gv_free[:name], :amount => gv_free[:amount], :currency => gv_free[:currency], :interval => gv_free[:interval], :location_limit => 1, :review_limit => 5
puts "Created #{gv_free[:name]} in local database"

Plan.find_or_create_by_identifier! :identifier => gv_30[:id], :name => gv_30[:name], :amount => gv_30[:amount], :currency => gv_30[:currency], :interval => gv_30[:interval], :location_limit => 1
puts "Created #{gv_30[:name]} in local database"

Plan.find_or_create_by_identifier! :identifier => gv_50[:id], :name => gv_50[:name], :amount => gv_50[:amount], :currency => gv_50[:currency], :interval => gv_50[:interval], :location_limit => 3
puts "Created #{gv_50[:name]} in local database"

Plan.find_or_create_by_identifier! :identifier => gv_agency[:id], :name => gv_agency[:name], :amount => gv_agency[:amount], :currency => gv_agency[:currency], :interval => gv_agency[:interval], :location_limit => nil, :review_limit => nil 
puts "Created #{gv_agency[:name]} in local database"

Plan.find_or_create_by_identifier! :identifier => gv_needs_to_pay[:id], :name => gv_needs_to_pay[:name], :amount => gv_needs_to_pay[:amount], :currency => gv_needs_to_pay[:currency], :interval => gv_needs_to_pay[:interval], :location_limit => 1, :review_limit => 0
puts "Created #{gv_needs_to_pay[:name]} in local database"

# Add Sources to Source Tables
# Source(id: integer, name: string, category: string, max_rating: decimal, accepts_management_response: boolean, management_response_url: string, main_url: string, created_at: datetime, updated_at: datetime) 

source1 = Source.find_or_create_by_name! name: 'yelp', category: 'general', max_rating: 5.0, accepts_management_response: true, management_response_url: 'https://biz.yelp.com/', main_url: 'http://www.yelp.com/'
puts "Added source: #{source1[:name]}, unless already in database"
source2 = Source.find_or_create_by_name! name: 'googleplus', category: 'general', max_rating: 5.0, accepts_management_response: true, management_response_url: 'http://www.google.com/placesforbusiness', main_url: 'http://www.google.com/places/'
puts "Added source: #{source2[:name]}, unless already in database"
source3 = Source.find_or_create_by_name! name: 'opentable', category: 'restaurants', max_rating: 5.0, accepts_management_response: true, management_response_url: 'http://www.otrestaurant.com/', main_url: 'http://www.opentable.com'
puts "Added source: #{source3[:name]}, unless already in database"
source4 = Source.find_or_create_by_name! name: 'tripadvisor', category: 'general', max_rating: 5.0, accepts_management_response: true, management_response_url: 'http://www.tripadvisor.com/Owners', main_url: 'http://www.tripadvisor.com'
puts "Added source: #{source4[:name]}, unless already in database"
source5 = Source.find_or_create_by_name! name: 'urbanspoon', category: 'restaurants', max_rating: 5.0, accepts_management_response: true, management_response_url: 'http://www.urbanspoon.com/u/signin', main_url: 'http://www.urbanspoon.com'
puts "Added source: #{source5[:name]}, unless already in database"
