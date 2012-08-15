### Setup behavior for Stripe
# Set keys (will change based on production or local dev)

stripe = if ENV['STRIPE_APP_ID'] and ENV['STRIPE_SECRET']
  { app_id: ENV['STRIPE_APP_ID'], secret: ENV['STRIPE_SECRET'] }
else
  path = Rails.root.join *%w[ config stripe.yml ]
  file = File.open path
  YAML.load(file).with_indifferent_access
end

STRIPE_PUBLIC_KEY = stripe[:app_id]
Stripe.api_key    = stripe[:secret]