# sample request to google places review api
# https://maps.googleapis.com/maps/api/place/details/json?reference=CnRmAAAAGg321uK8xOiQRZguEZvxKwZXqwzShD1Mx5rW7bolqViOIC4anBbtDrqZDaJ2KSdrEoDgdOhxuwtwI35QlDEgvhFmkPek-MDkV3Gj8ZGMz-wQlAWjbiSIjeVu8pB6Yy8iE5dMIK0fLl4e4Mh0Lu9ihhIQwUApDK4XMZazepOYt6XJQBoUgvF1h4j1OCCNCfVnRmcpbvJwIpE&sensor=true&key=AIzaSyAfzgIC3a-sxgoaFMZ7nZn9ioSZfwMenhM

require 'open-uri'
require 'debugger'
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
		response = RestClient.get "#{@uri}", {:params => {:reference => "#{@location_id}", :sensor => "#{@sensor}", :key => "#{@key}"}}
		parsed_response = JSON.parse(response)

		new_reviews = []

		parsed_response["result"]["reviews"].each do |review|

			review_date = Time.at(review["time"]).to_date
			if review_date >= Date.strptime(latest_review[:post_date], "%m/%d/%Y")
				next if review["text"].chomp == latest_review[:comment].chomp
				new_review = {}
				new_review[:post_date] = Time.at(review["time"]).to_date
				new_review[:comment] = review["text"].chomp
				

				if !review["author_name"].nil?
					new_review[:author] = review["author_name"]
					new_review[:author_url] = review["author_url"]
				else
					new_review[:author] = "A Google User"
				end

				# handle google's crazy rating system, only checking for 'service'
				google_review_rating = review["aspects"][2]["rating"].to_i
				case google_review_rating
					when 3
						new_review[:rating] = 5
					when 2
						new_review[:rating] = 4
					when 1
						new_review[:rating] = 3
					else
						new_review[:rating] = 2
				end

				new_reviews << new_review
			end
		end
		new_reviews
	end
end