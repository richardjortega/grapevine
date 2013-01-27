require 'open-uri'
require 'httparty'

class Google
	def initialize
		@sensor = false
		@radius = 500
		@output = 'json'
		@key = 'AIzaSyBZMXlt7q31RrFXUvwglhPwIIi_TabjfNU'
		track_api_call('googleplus')
	end

	def track_api_call(source_name)
		source_id = Source.find_by_name("#{source_name}")
		Source.update_counters(source_id, :api_count_daily => 1)
	end

	def get_location_id(term, lat, long)
		begin
		parsed_term = URI.parse(URI.encode(term.strip))
		path = "https://maps.googleapis.com/maps/api/place/nearbysearch/#{@output}?location=#{lat},#{long}&keyword=#{parsed_term}&radius=#{@radius}&sensor=#{@sensor}&key=#{@key}"
		response = HTTParty.get(path)
		
		# Handle Zero Results
		if response['results'].empty?
			puts "Found no results, moving on..."
			return
		end
		# Check each location
		# Google may return a completely different type of result (needs work)
		location_id = nil
		response['results'].each do |result|
			result_lat = result['geometry']['location']['lat']
			result_long = result['geometry']['location']['lng']
			result_id = result['reference']
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

	def get_new_reviews(latest_review, location_id)
		begin
		path = "https://maps.googleapis.com/maps/api/place/details/#{@output}?reference=#{location_id}&sensor=#{@sensor}&key=#{@key}"
		parsed_response = HTTParty.get(path)
		url = parsed_response["result"]["url"]

		new_reviews = []

		# Handle no reviews
		if !parsed_response["result"]["reviews"].present?
			puts "There are no reviews for this restaurant"
			return
		end

		parsed_response["result"]["reviews"].each do |review|
			review_date = Time.at(review["time"]).to_date
			review_comment = review["text"].strip
			
			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= latest_review[:post_date]
				next if review_comment == latest_review[:comment].strip
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review_comment
				new_review[:url] = url

				if !review["author_name"].nil?
					new_review[:author] = review["author_name"]
					new_review[:author_url] = review["author_url"]
				else
					new_review[:author] = "A Google User"
				end

				aspect_ratings = []
				review["aspects"].each do |aspect|
					aspect_ratings << aspect["rating"]
				end
				overall_review_rating = aspect_ratings.inject{|sum, el| sum + el}.to_f / aspect_ratings.size
				
				case overall_review_rating
					when 3
						new_review[:rating] = 5
						new_review[:rating_description] = 'Excellent'
					when 2
						new_review[:rating] = 4
						new_review[:rating_description] = 'Very Good'
					when 1
						new_review[:rating] = 3
						new_review[:rating_description] = 'Fair'
					else
						new_review[:rating] = 2
						new_review[:rating_description] = 'Poor'
				end
				new_reviews << new_review
			end
		end
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{location_id} page, moving on..."
		end

		new_reviews
	end
end