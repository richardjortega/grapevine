require 'open-uri'
require 'httparty'
require 'nokogiri'

class OpenTable
	def initialize
		apiversion = '4.9'
		passkey = 'tjp43pshizud7jpex6rokvyop'
		limit = 5
		@url = "http://reviews.opentable.com/data/reviews.json?apiversion=#{apiversion}&passkey=#{passkey}&sort=submissiontime:desc&limit=#{limit}&filter=IsRatingsOnly:false&include=products&stats=reviews"
	end

	def get_location_id(term, street_address, city, state, zip)
		query = "#{term} #{street_address} #{city} #{state} #{zip}"
		parsed_query = URI.parse(URI.encode(query.strip))
		cx = "009410204525769731320:tbwceh9avj4"
		key = "AIzaSyBZMXlt7q31RrFXUvwglhPwIIi_TabjfNU"
		path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
		response = HTTParty.get(path)
		if response['spelling']
			puts "This query (location or address) is likely spelled wrong, please fix it."
			puts "Recommended/Corrected Query: #{response['spelling']['correctedQuery']}"
		end
		if response['error']
			code = response['error']['code']
			message = response['error']['message']
			puts "Error found: #{code} | Message: #{message} | Google Search API quota may have been reached"
		end
		location_url = ""
		response['items'].each do |result|
			postal_address = result['pagemap']['postaladdress'][0]['streetaddress'] rescue "Couldn't find a postal address to compare to, be more specific."
			if postal_address.include?("#{zip}")
				puts "Found a search result that matches the zip code provided."
				location_url = result['link'] rescue "Could not find any matching information"
				break
			else
				puts "Found a search result that doesn't match the zip code provided. Please be more specific in searching."
			end
		end
		location_id = get_restaurant_id(location_url)
	end

	def get_restaurant_id(location_url)
		doc = Nokogiri::HTML(open(location_url))
		restaurant_id = doc.css('input#SearchBox_RestSearchBox_txtHid_RestaurantID').attribute('value').value
	end

	def get_new_reviews(latest_review, location_id)
		begin
		@request = @url + URI.encode("&filter=ProductId:#{location_id}&RestaurantID=#{location_id}")
		response = HTTParty.get(@request)

		new_reviews = []
		response["Results"].each do |review|
			review_date = Date.strptime(review["AdditionalFields"][1]["Value"], "%m/%d/%Y")
			review_comment = review["ReviewText"].strip
			
			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= latest_review[:post_date]
				next if review_comment == latest_review[:comment].chomp
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review_comment
				new_review[:author] = 'OpenTable Diner'
				new_review[:rating] = review["Rating"].to_i
				new_review[:title] = review["Title"]
				new_review[:url] = "http://www.opentable.com/rest_profile.aspx?rid=#{location_id}&tab=2"
				new_reviews << new_review
			end
		end

		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{@request} page, moving on..."
		end

		new_reviews
	end
end