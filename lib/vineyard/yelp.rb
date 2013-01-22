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

		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		@access_token = OAuth::AccessToken.new(consumer, token, token_secret)
	end

	def get_location_id(term, lat, long)
		parsed_term = URI.parse(URI.encode(term.strip))
		path = "/v2/search?term=#{parsed_term}&ll=#{lat},#{long}"
		response = JSON.parse(@access_token.get(path).body)
		location_id = nil
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
	end

	def get_new_reviews(latest_review, location_id)	
		parsed_location_id = URI.parse(URI.encode(location_id.strip))
		path = "/v2/business/#{parsed_location_id}"	
		response = JSON.parse(@access_token.get(path).body)
		url = response["url"]

		new_reviews = []
		response["reviews"].each do |review|
			review_date = Time.at(review["time_created"]).to_date
			review_comment = review["excerpt"].strip
			
			if review_date >= latest_review[:post_date]
				next if review_comment == latest_review[:comment].chomp
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


