#these are test keys!!! live keys are on heroku
## Add your stripe api key to your heroku config environment
##	https://manage.stripe.com/#account/apikeys
##	heroku config:add STRIPE_SECRET_KEY=<YOUR_KEY>
#note, any time changing this key, please update the HooksController
STRIPE_SECRET_KEY = "tJhooWqaOtgRuLxkGogSLTL3sLxEU4ak"
#global, set into in Users#New
STRIPE_PUBLISHABLE_KEY = "pk_bAEZXsFEaF2YxPP7rzt12lH6e4JaL"


#old test
#Stripe.api_key = "tJhooWqaOtgRuLxkGogSLTL3sLxEU4ak"