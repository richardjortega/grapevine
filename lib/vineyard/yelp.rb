require 'oauth'
require 'json'

class Yelp
	def initialize(location_id)
	 	consumer_key = 'CoPn_PDLyBIom28EwW_vcg'
		consumer_secret = 'v6VqDXMzGUpLEnbCGx6xDAwG4OM'
		token = '8UmXzrrFzbAffWuTpjTiOQkiFKJ3KZzY'
		token_secret = 'uADpLMg0_BuzFaTWP3GOie9qIQU'
		api_host = 'api.yelp.com'

		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		@access_token = OAuth::AccessToken.new(consumer, token, token_secret)
		@path = "/v2/business/#{location_id}"
	end

	def get_new_reviews(latest_review)		
		response = JSON.parse(@access_token.get(@path).body)
		url = response["url"]

		new_reviews = []
		response["reviews"].each do |review|
			review_date = Time.at(review["time_created"]).to_date
			if review_date >= Date.strptime(latest_review[:post_date], "%m/%d/%Y")
				next if review["excerpt"].chomp == latest_review[:comment].chomp
				new_review = {}
				new_review[:post_date] = Time.at(review["time_created"]).to_date
				new_review[:comment] = review["excerpt"].strip
				new_review[:author] = review["user"]["name"]
				new_review[:rating] = review["rating"].to_i
				new_review[:url] = url
				new_reviews << new_review
			end
		end
		new_reviews
	end
end


