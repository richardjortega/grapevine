require 'open-uri'
require 'httparty'

class Googleplus
	def initialize
		@sensor = false
		@radius = 500
		@output = 'json'
		@key = 'AIzaSyBZMXlt7q31RrFXUvwglhPwIIi_TabjfNU'
		@source = Source.find_by_name('googleplus')
		track_api_call
	end

	def get_location_id_status?
		true
	end

	def get_new_reviews_status?
		true
	end

	def get_location_id(location)
		begin
		parsed_term = URI.parse(URI.encode(location.name.strip))
		path = "https://maps.googleapis.com/maps/api/place/nearbysearch/#{@output}?location=#{location.lat.to_f},#{location.long.to_f}&keyword=#{parsed_term}&radius=#{@radius}&sensor=#{@sensor}&key=#{@key}"
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
			delta = Geocoder::Calculations.distance_between([location.lat.to_f,location.long.to_f],[result_lat,result_long])

			if delta < 0.25
				puts "Matching found location '#{result_name}' to given location: #{location.name}"
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

	def fetch_data(location)
		source_location_uri = location.vines.find_by_source_id(@source.id).source_location_uri
		path = "https://maps.googleapis.com/maps/api/place/details/#{@output}?reference=#{source_location_uri}&sensor=#{@sensor}&key=#{@key}"
		HTTParty.get(path)
	end

	def get_new_reviews(location, options = {})
		begin
		latest_review_date = options[:latest_review_date] || Date.today - 2
		latest_comments = options[:latest_comments] || ''

		response = fetch_data(location)

		#Handle blank response
		if response.blank?
			puts "GV Alert: The returned response was blank, please look into #{location.name}"
			return
		end

		# Handle no reviews
		if !response["result"]["reviews"].present?
			puts "There are no reviews for this restaurant"
			return
		end

		new_reviews = compare_reviews_to_latest_reviews(response, latest_review_date, latest_comments)

		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{location.name} page, moving on..."
		end
	end

private
	
	def compare_reviews_to_latest_reviews(response, latest_review_date, latest_comments)
		new_reviews = []

		url = response["result"]["url"]
		response["result"]["reviews"].each do |review|
			review_date = Time.at(review["time"]).to_date
			review_comment = review["text"].strip
			
			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= latest_review_date
				next if latest_comments.include?(review_comment)
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
		new_reviews
	end

	def track_api_call
		Source.update_counters(@source, :api_count_daily => 1)
	end
end