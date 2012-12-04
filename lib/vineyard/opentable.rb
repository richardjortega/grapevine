require 'net/http'
require 'open-uri'
require 'debugger'
require 'HTTParty'

class OpenTable
	
	def initialize()
		apiversion = '4.9'
		passkey = 'tjp43pshizud7jpex6rokvyop'
		limit = 15
		@url = "http://reviews.opentable.com/data/reviews.json?apiversion=#{apiversion}&passkey=#{passkey}&sort=submissiontime:desc&limit=#{limit}&filter=IsRatingsOnly:false&include=products&stats=reviews"
	end

	def parse_review_page(location_id)
		request = @url + URI.encode("&filter=ProductId:#{location_id[:location_id]}&RestaurantID=#{location_id[:location_id]}")
		response = HTTParty.get(request)
	end

end



# http://reviews.opentable.com/data/reviews.json?apiversion=4.9&passkey=tjp43pshizud7jpex6rokvyop&sort=submissiontime:desc&limit=15&filter=ProductId:28474&filter=IsRatingsOnly:false&include=products&stats=reviews&RestaurantID=28474'