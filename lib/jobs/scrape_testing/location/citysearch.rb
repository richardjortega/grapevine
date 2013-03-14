#API wrapper for CityGrid API (a.k.a CitySearch, InsiderPages, Judy's Book)
require 'rubygems'
require 'httparty'
require 'ap'
require 'debugger'
#require_relative "../../app/models/review"

# class CitySearchApiParser

# 	 def parse_reviews_firstresponsepage_for_location(location)
	 	publisher_code = '10000001524'

	 	#use in production when passing location id
	 	#path = "http://api.citygridmedia.com/content/reviews/v2/search/where?publisher=#[publisher_code}&listing_id=#{location}&sort=createdate&rpp=50"

	 	#used to test in development
	 	path = "http://api.citygridmedia.com/content/reviews/v2/search/where?publisher=#{publisher_code}&listing_id=10094656&sort=createdate&rpp=50"

		business = HTTParty.get(path)

		#play with the data
		reviews = Array.new
		business["results"]["reviews"]["review"].each do |review|
			parsed_review = {}
			parsed_review[:rating] = review["review_rating"]
			parsed_review[:author] = review["review_author"]
			parsed_review[:comment] = review["review_text"]
			parsed_review[:date] = Date.parse(review["review_date"])
			reviews << parsed_review
		end

		ap reviews
# 	end

# end