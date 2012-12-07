require 'open-uri'
require 'HTTParty'
require 'debugger'

class OpenTable
	def initialize()
		apiversion = '4.9'
		passkey = 'tjp43pshizud7jpex6rokvyop'
		limit = 5
		@url = "http://reviews.opentable.com/data/reviews.json?apiversion=#{apiversion}&passkey=#{passkey}&sort=submissiontime:desc&limit=#{limit}&filter=IsRatingsOnly:false&include=products&stats=reviews"
	end

	def get_new_reviews(location_id, latest_review)
		request = @url + URI.encode("&filter=ProductId:#{location_id}&RestaurantID=#{location_id}")
		response = HTTParty.get(request)

		new_reviews = []
		latest_review = latest_review
		response["Results"].each do |review|
			review_date = Date.strptime(review["AdditionalFields"][1]["Value"], "%m/%d/%Y")
			if review_date >= Date.strptime(latest_review[:post_date], "%m/%d/%Y")
				next if review["ReviewText"].chomp == latest_review[:comment].chomp
				new_review = {}
				new_review[:post_date] = Date.strptime(review["AdditionalFields"][1]["Value"], "%m/%d/%Y")
				new_review[:comment] = review["ReviewText"]
				new_review[:author] = 'OpenTable Diner'
				new_review[:rating] = review["Rating"]
				new_review[:title] = review["Title"]
				new_reviews << new_review
			end
		end
		new_reviews
	end
end



# http://reviews.opentable.com/data/reviews.json?apiversion=4.9&passkey=tjp43pshizud7jpex6rokvyop&sort=submissiontime:desc&limit=15&filter=ProductId:28474&filter=IsRatingsOnly:false&include=products&stats=reviews&RestaurantID=28474