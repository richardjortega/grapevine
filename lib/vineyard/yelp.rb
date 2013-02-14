require 'oauth'
require 'json'
require 'open-uri'

class Yelp
	def initialize
	 	consumer_key = 'CoPn_PDLyBIom28EwW_vcg'
		consumer_secret = 'v6VqDXMzGUpLEnbCGx6xDAwG4OM'
		token = '8UmXzrrFzbAffWuTpjTiOQkiFKJ3KZzY'
		token_secret = 'uADpLMg0_BuzFaTWP3GOie9qIQU'
		api_host = 'api.yelp.com'
		@source = Source.find_by_name('yelp')
		track_api_call

		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		@access_token = OAuth::AccessToken.new(consumer, token, token_secret)
	end


	

	def get_location_id(term, lat, long)
		begin
		parsed_term = URI.parse(URI.encode(term.strip))
		path = "/v2/search?term=#{parsed_term}&ll=#{lat},#{long}"
		response = JSON.parse(@access_token.get(path).body)
		
		location_id = nil
		return if api_limit_exceeded?(response)

		# Check each location
		response['businesses'].each do |result|
			#Check lat and long against lat and long of resulted
			result_lat = result['location']['coordinate']['latitude']
			result_long = result['location']['coordinate']['longitude']
			result_id = result['id']
			result_name = result['name']
			delta = Geocoder::Calculations.distance_between([lat.to_f,long.to_f],[result_lat,result_long])

			if delta < 0.25
				puts "Matching found location '#{result_name}' to given location: #{term}"
				location_id = result_id rescue "Could not find any matching information"
				break
			else
				puts "Result is too far away from location. Distance is #{delta} miles. Location: #{result_name}"
			end
		end
		# If no results match what we are looking for 'location_id' will return nil
		location_id
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered an error, moving on..."
		end
	end

	def fetch_reviews(location)
		source_location_uri = location.vines.find_by_source_id(@source.id).source_location_uri
		puts "Searching for new reviews at: #{source_location_uri}"
		parsed_location_id = URI.parse(URI.encode(source_location_uri.strip))
		path = "/v2/business/#{parsed_location_id}"	
		JSON.parse(@access_token.get(path).body)
	end

	def get_new_reviews(location, options = {})	
		begin

		if options[:latest_five_reviews]
			latest_reviews = options[:latest_five_reviews]
			latest_review_date = latest_reviews.sort_by(&:post_date).reverse.first.post_date
			latest_comments = latest_reviews.map(&:comment)
		else
			default_post_date = Date.today - 2
			latest_review_date = default_post_date
			latest_comments = ''
		end

		response = fetch_reviews(location)

		return if api_limit_exceeded?(response)
		return if response['reviews'].nil?

		new_reviews = compare_reviews_to_latest_reviews(response, latest_review_date, latest_comments)

		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered an error, moving on..."
		end
	end

private
	def api_limit_exceeded?(response)
		# Handle Yelp API query limit
		if response['error'].present?
			puts "GV Review Alert: Yelp Error - #{response['error']['text']}"
			true
		else
			false
		end
	end

	def track_api_call
		Source.update_counters(@source, :api_count_daily => 1)
	end

	def compare_reviews_to_latest_reviews(response, latest_review_date, latest_comments)
		new_reviews = []
		
		url = response["url"]
		response["reviews"].each do |review|
			review_date = Time.at(review["time_created"]).to_date
			review_comment = review["excerpt"].strip
			
			if review_date >= latest_review_date
				next if latest_comments.include?(review_comment)
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review_comment
				new_review[:author] = review["user"]["name"]
				new_review[:rating] = review["rating"].to_i
				new_review[:url] = url
				new_reviews << new_review
			end
		end
		new_reviews
	end

end
