require 'open-uri'
require 'httparty'

class Google
	def initialize
		@sensor = false
		@radius = 500
		@output = 'json'
		@key = 'AIzaSyAfzgIC3a-sxgoaFMZ7nZn9ioSZfwMenhM'
	end

	def get_location_id(term, lat, long)
		parsed_term = URI.parse(URI.encode(term.strip))
		path = "https://maps.googleapis.com/maps/api/place/nearbysearch/#{@output}?location=#{lat},#{long}&keyword=#{parsed_term}&radius=#{@radius}&sensor=#{@sensor}&key=#{@key}"
		response = HTTParty.get(path)
		location_id = response['results'][0]['reference'] rescue 'No Google Information Found Near These Coordinates and Search Term'
	end

	def get_new_reviews(latest_review, location_id)
		begin
		path = "https://maps.googleapis.com/maps/api/place/details/#{@output}?reference=#{location_id}&sensor=#{@sensor}&key=#{@key}"
		response = HTTParty.get(path)
		debugger
		
		new_reviews = []

		parsed_response["result"]["reviews"].each do |review|
			review_date = Time.at(review["time"]).to_date
			review_comment = review["text"].strip
			
			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= Date.strptime(latest_review[:post_date], "%m/%d/%Y")
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