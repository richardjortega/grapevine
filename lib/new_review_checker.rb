module NewReviewsChecker	
	def self.is_new?(review, lastest_review_date) 
		# format incoming review date
		review_date_to_check = Date.strptime(latest_review_date, "%m/%d/%Y")

		


		# # checks new reviews against old reviews in array and only returns new ones.
		# # Use order for AR when referencing DB
		# # latest_review_date = Location.Reviews.order("review_dine_date DESC").first.review_dine_date
		# latest_review_date = Date.strptime(current_reviews.first[:review_dine_date], "%m/%d/%Y")

		# new_reviews_to_add = []
		# new_reviews.each do |review|
		# 	# compare each review  and check if their dates are newer than latest in DB/array
		# 	parsed_review_date = Date.strptime(review[:review_dine_date], "%m/%d/%Y")
		# 	if parsed_review_date >= latest_review_date
		# 		next if current_reviews.first[:review_description].chomp == review[:review_description].chomp
		# 		new_reviews_to_add << review
		# 	end
		# end
		# new_reviews_to_add
	end
end