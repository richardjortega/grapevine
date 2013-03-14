#API wrapper for Yellow Pages
require 'rubygems'
require 'httparty'
require 'ap'
require 'debugger'
#require_relative "../../app/models/review"

# class YellowPagesApiParser

# 	 def parse_reviews_firstresponsepage_for_location(location)
	 	api_key = '60b600e8f711a25ceebc5c3df40f35a9'

	 	#use in production when passing location id
	 	#grabbed from: http://www.yellowpages.com/san-antonio-tx/mip/zinc-460570596?lid=460570596
	 	#path = "http://api2.yp.com/listings/v1/reviews?listingid=#{location}&key=#{api_key}"

	 	#used to test in development
	 	path = "http://api2.yp.com/listings/v1/reviews?listingid=460570596&key=#{api_key}"

		business = HTTParty.get(path)

		#play with the data
		reviews = Array.new
		business["ratingsAndReviewsResult"]["reviews"]["review"].each do |review|
			parsed_review = {}
			parsed_review[:title] = review["reviewSubject"]
			parsed_review[:rating] = review["rating"]
			parsed_review[:author] = review["reviewer"]
			parsed_review[:comment] = review["reviewBody"]
			parsed_review[:date] = Date.parse(review["reviewDate"])
			reviews << parsed_review
		end

		ap reviews
# 	end

# end