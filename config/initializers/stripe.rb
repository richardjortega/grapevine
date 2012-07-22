stripe = if ENV['STRIPE_PUBLISHABLE_KEY'] and ENV['STRIPE_SECRET_KEY']
  { app_id: ENV['STRIPE_PUBLISHABLE_KEY'], secret: ENV['STRIPE_SECRET_KEY'] }
else
  path = Rails.root.join *%w[ config stripe.yml ]
  file = File.open path
  YAML.load(file).with_indifferent_access
end

STRIPE_PUBLIC_KEY = stripe[:STRIPE_PUBLISHABLE_KEY]
Stripe.api_key    = stripe[:STRIPE_SECRET_KEY]


##	https://manage.stripe.com/#account/apikeys
##	heroku config:add STRIPE_SECRET_KEY=<YOUR_KEY>
# # Add unix config vars like this to code, took forever to find out: '<%= ENV["STRIPE_PUBLISHABLE_KEY"] %>'
# STRIPE_SECRET_KEY = "tJhooWqaOtgRuLxkGogSLTL3sLxEU4ak"
# STRIPE_PUBLISHABLE_KEY = "pk_bAEZXsFEaF2YxPP7rzt12lH6e4JaL"

# #old test
# #Stripe.api_key = "tJhooWqaOtgRuLxkGogSLTL3sLxEU4ak"