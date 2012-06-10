##	https://manage.stripe.com/#account/apikeys
##	heroku config:add STRIPE_SECRET_KEY=<YOUR_KEY>
# Add unix config vars like this to code, took forever to find out: '<%= ENV["STRIPE_PUBLISHABLE_KEY"] %>'
STRIPE_SECRET_KEY = "tJhooWqaOtgRuLxkGogSLTL3sLxEU4ak"
STRIPE_PUBLISHABLE_KEY = "pk_bAEZXsFEaF2YxPP7rzt12lH6e4JaL"

#old test
#Stripe.api_key = "tJhooWqaOtgRuLxkGogSLTL3sLxEU4ak"