require 'open-uri'
require 'HTTParty'
require 'debugger'

class TripAdvisor
	def initialize(location_id)
		@location_id = location_id
		apiversion = '4.9'
		passkey = 'tjp43pshizud7jpex6rokvyop'
		limit = 5
		url = "http://reviews.opentable.com/data/reviews.json?apiversion=#{apiversion}&passkey=#{passkey}&sort=submissiontime:desc&limit=#{limit}&filter=IsRatingsOnly:false&include=products&stats=reviews"
		@request = url + URI.encode("&filter=ProductId:#{@location_id}&RestaurantID=#{@location_id}")
	end

	def get_new_reviews(latest_review)
		begin
		response = HTTParty.get(@request)

		new_reviews = []
		response["Results"].each do |review|
			review_date = Date.strptime(review["AdditionalFields"][1]["Value"], "%m/%d/%Y")
			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= Date.strptime(latest_review[:post_date], "%m/%d/%Y")
				next if review["ReviewText"].chomp == latest_review[:comment].chomp
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review["ReviewText"]
				new_review[:author] = 'OpenTable Diner'
				new_review[:rating] = review["Rating"].to_i
				new_review[:title] = review["Title"]
				new_review[:url] = "http://www.opentable.com/rest_profile.aspx?rid=#{@location_id}&tab=2"
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