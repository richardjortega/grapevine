require 'open-uri'
require 'httparty'
require 'nokogiri'

class Opentable
	def initialize
		apiversion = '4.9'
		passkey = 'tjp43pshizud7jpex6rokvyop'
		limit = 5
		@url = "http://reviews.opentable.com/data/reviews.json?apiversion=#{apiversion}&passkey=#{passkey}&sort=submissiontime:desc&limit=#{limit}&filter=IsRatingsOnly:false&include=products&stats=reviews"
		@source = Source.find_by_name('opentable')
		track_api_call
	end

	def get_location_id(term, street_address, city, state, zip)
		begin
		query = "#{term} #{street_address} #{city} #{state} #{zip}"
		parsed_query = URI.parse(URI.encode(query.strip))
		cx = "009410204525769731320:tbwceh9avj4"
		key = "AIzaSyBZMXlt7q31RrFXUvwglhPwIIi_TabjfNU"
		path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
		response = HTTParty.get(path)
		# Handle zero results
		if response['queries']['request'][0]['totalResults'].to_i == 0
			puts "Found no results, moving on..."
			return
		end
		# Handle spelling errors (must be handled first)
		if response['spelling']
			puts "This query (location or address) is likely spelled wrong, please fix it."
			puts "Recommended/Corrected Query: #{response['spelling']['correctedQuery']}"
			puts "Reruning search with Corrected Query: #{response['spelling']['correctedQuery']}"
			query = "#{response['spelling']['correctedQuery']}"
			parsed_query = URI.parse(URI.encode(query.strip))
			path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
			response = HTTParty.get(path)
		end
		# Handle error responses
		if response['error']
			code = response['error']['code']
			message = response['error']['message']
			puts "Error found: #{code} | Message: #{message} | Google Search API quota may have been reached"
			return
		end
		
		# Check each location using zip comparison
		location_url = nil
		response['items'].each do |result|
			postal_address = result['pagemap']['postaladdress'][0]['streetaddress'] rescue "Couldn't find a postal address to compare to, be more specific or this is the wrong link."
			if postal_address.include?("#{zip}")
				puts "Found a search result that matches the zip code provided."
				location_url = result['link'] rescue "Could not find any matching information"
				break
			else
				puts "Found a search result that doesn't match the zip code provided. Checking next result."
			end
		end
		# If no results match what we are looking for 'location_id' will return nil
		return if location_url.nil?
		location_id = get_restaurant_id(location_url)
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered an error, moving on..."
		end
	end

	def get_restaurant_id(location_url)
		begin
		doc = Nokogiri::HTML(open(location_url))
		restaurant_id = doc.css('input#SearchBox_RestSearchBox_txtHid_RestaurantID').attribute('value').value
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered an error, moving on..."
		end
	end

	def fetch_data(location)
		source_location_uri = location.vines.find_by_source_id(@source.id).source_location_uri
		@request = @url + URI.encode("&filter=ProductId:#{source_location_uri}&RestaurantID=#{source_location_uri}")
		@simple_url = "http://www.opentable.com/rest_profile.aspx?rid=#{source_location_uri}&tab=2"
		HTTParty.get(@request)
	end

	def get_new_reviews(location, options = {})
		begin
		latest_review_date = options[:latest_review_date] || Date.today - 2
		latest_comments = options[:latest_comments] || ''

		response = fetch_data(location)
		return if response.nil?
		
		new_reviews = compare_reviews_to_latest_reviews(response, latest_review_date, latest_comments)

		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{@request} page, moving on..."
		end
	end

private

	def compare_reviews_to_latest_reviews(response, latest_review_date, latest_comments)
		new_reviews = []
		response["Results"].each do |review|
			review_date = Date.strptime(review["AdditionalFields"][1]["Value"], "%m/%d/%Y")
			review_comment = review["ReviewText"].strip
			
			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= latest_review_date
				next if latest_comments.include?(review_comment)
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review_comment
				new_review[:author] = 'OpenTable Diner'
				new_review[:rating] = review["Rating"].to_i
				new_review[:title] = review["Title"]
				new_review[:url] = @simple_url
				new_reviews << new_review
			end
		end
		new_reviews
	end
	
	def track_api_call
		Source.update_counters(@source, :api_count_daily => 1)
	end

end