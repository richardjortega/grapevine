### Setup behavior for Stripe
# Set keys (will change based on production or local dev)

stripe = if ENV['STRIPE_PUBLISHABLE_KEY'] and ENV['STRIPE_SECRET_KEY']
  { app_id: ENV['STRIPE_PUBLISHABLE_KEY'], secret: ENV['STRIPE_SECRET_KEY'] }
else
  path = Rails.root.join *%w[ config stripe.yml ]
  file = File.open path
  YAML.load(file).with_indifferent_access
end

STRIPE_PUBLIC_KEY = stripe[:STRIPE_PUBLISHABLE_KEY]
Stripe.api_key    = stripe[:STRIPE_SECRET_KEY]



