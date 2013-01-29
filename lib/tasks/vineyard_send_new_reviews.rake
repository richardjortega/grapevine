# Send all new reviews found for locations

namespace :vineyard do
	desc 'Send new reviews for all locations'
	task :send_new_reviews => :environment do
		Review.find(:all, :order => 'created_at').each do |review|
			# User assumes only one user per location (needs refactoring for multi-user)
			user = review.location.users.first
			user_id = user.id

			# Check user's plan first (check for free plans)
			if user.plan.identifier == 'gv_free'

			else
				# Send review
				# mark review sent
				# increment user's review
				User.update_counters(user_id, :api_count_daily => 1)
			end
			## If 'gv_free'
				#
		end
	end
end