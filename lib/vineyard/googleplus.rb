require 'open-uri'
require 'rest_client'
require 'json'

class GooglePlus
	def initialize(location_id)
		@uri = URI.parse('https://maps.googleapis.com/maps/api/place/details/json')
		@location_id = location_id
		@sensor = true
		@key = 'AIzaSyAfzgIC3a-sxgoaFMZ7nZn9ioSZfwMenhM'
	end

	def get_new_reviews(latest_review)
		begin
		response = RestClient.get "#{@uri}", {:params => {:reference => "#{@location_id}", :sensor => "#{@sensor}", :key => "#{@key}"}}
		parsed_response = JSON.parse(response)

		new_reviews = []

		parsed_response["result"]["reviews"].each do |review|
			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			review_date = Time.at(review["time"]).to_date
			if review_date >= Date.strptime(latest_review[:post_date], "%m/%d/%Y")
				next if review["text"].chomp == latest_review[:comment].chomp
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review["text"].chomp
				

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
			puts "Encountered error on #{@location_id} page, moving on..."
		end

		new_reviews
	end
end