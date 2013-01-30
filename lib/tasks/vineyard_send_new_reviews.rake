# Send all new reviews found for locations

namespace :vineyard do
	desc 'Send new reviews for all locations'
	task :send_new_reviews => :environment do
		Review.find(:all, :order => 'created_at').each do |review|
			# User assumes only one user per location (needs refactoring for multi-user)
			user = review.location.users.first
			user_id = user.id

			# Set everything needed for review alert

			if Rails.env.development?
				# for testing locally
				email = 'info+test@pickgrapevine.com'
			else
				# for production and staging environments
				email = user.email
			end

			comment = review.comment
			rating = review.rating.to_f
			source = review.source.name
			location = review.location.name
			location_link = review.url

			# Change user's review_count to zero if nil
			user.review_count = 0 if user.review_count.nil?
			review_count = user.review_count

			# Check user's plan first (check for free plans)
			if user.plan.identifier == 'gv_free'
				plan_type = 'free'
				if review_count <= 4
					# increment user's review
					review_count += 1

					# Send the review
					puts "Sending a review alert to #{location} to #{email}"
					NotifyMailer.delay({:run_at => 6.hours.from_now}).review_alert(email, comment, rating, source, location, location_link, review_count, plan_type)

					# mark review sent
					review.status = 'sent'
					review.status_updated_at = Time.now
					review.save!
					user.save!
				else
					# Handles people who hit their max review count

					# Don't send the review
					# Mark review 'archive'
					puts "Not sending a review because user's review count has hit the max"
					review.status = 'archive'
					review.status_updated_at = Time.now
					review.save!

					# Alert us about users who have maxed out
					if review_count == 5
						DelayedKiss.record(email, 'User Hit Max Review Count', {'Location' => "#{location}"})
						NotifyMailer.delay.update_grapevine_team(user, "User has just hit their max review")
					end
				end
			else
				plan_type = 'paid'
				# Handles people with paid plan_types

				# increment user's review
				review_count += 1

				# Send the review
				puts "Sending a review alert to #{location} to #{email}"
				NotifyMailer.delay({:run_at => 6.hours.from_now}).review_alert(email, comment, rating, source, location, location_link, review_count, plan_type)

				# mark review sent
				review.status = 'sent'
				review.status_updated_at = Time.now
				review.save!
				user.save!
			end
		end
	end
end