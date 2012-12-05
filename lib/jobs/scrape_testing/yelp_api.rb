#API wrapper for Yelp API
require 'rubygems'
require 'oauth'
require 'json'
require 'ap'
# require_relative "../../app/models/review"

# class YelpApiParser

# 	 def parse_reviews_firstresponsepage_for_location(location)
	 	consumer_key = 'CoPn_PDLyBIom28EwW_vcg'
		consumer_secret = 'v6VqDXMzGUpLEnbCGx6xDAwG4OM'
		token = '8UmXzrrFzbAffWuTpjTiOQkiFKJ3KZzY'
		token_secret = 'uADpLMg0_BuzFaTWP3GOie9qIQU'

		api_host = 'api.yelp.com'

		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		access_token = OAuth::AccessToken.new(consumer, token, token_secret)

		#path to use in production, accepting location
		#path = "/v2/business/#{location}"

		#path to use while testing/dev
		path = "/v2/business/rosarios-mexican-cafe-y-cantina-san-antonio"

		# Using Ruby JSON
		business = JSON.parse(access_token.get(path).body)

		ap business

		#play with the data
		# reviews = Array.new

		# business["reviews"].each do |reviews|
		# 	parsed_review = Review.new
		# 	parsed_review.rating = reviews["rating"]
		# 	parsed_review.author = reviews["user.name"]
		# 	parsed_review.comment = reviews["excerpt"]
		# 	parsed_review.date = reviews["time_created"]
		# 	reviews << parsed_review
		# end
# 	end

# end


