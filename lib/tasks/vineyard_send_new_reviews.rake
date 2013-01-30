# Send all new reviews found for locations

namespace :vineyard do
	desc 'Send new reviews, production, send now'
	task 'send_new_reviews:now' do
		Rake::Task['vineyard:send_new_reviews'].invoke(true)
	end

	desc 'Send new reviews for all locations'
	task :send_new_reviews, [:run_now] => :environment do |t, args|
		args.with_defaults(:run_now => false)
		new_reviews = Review.where('status = ?', 'new').order('created_at DESC')
		if new_reviews.empty?
			puts "GV Review Alert: No new reviews found from yesterday. No sending needed."
			next
		end
		new_reviews.each do |review|
			# User assumes only one user per location (needs refactoring for multi-user)
			user = review.location.users.first
			user_id = user.id
			email = user.email

			# Set args
			run_now = args[:run_now]

			# Change user's review_count to zero if nil
			user.review_count = 0 if user.review_count.nil?
			review_count = user.review_count

			# Check user's plan first (check for free plans)
			if user.plan.identifier == 'gv_free'
				plan_type = 'free'
				if review_count <= 4
					# increment user's review
					review_count += 1
					user.save!

					# Send the review
					send_new_review(email, review, review_count, plan_type, run_now)
					

					# mark review sent
					review.status = 'sent'
					review.status_updated_at = Time.now
					review.save!

				else
					# Handles people who hit their max review count

					# Don't send the review
					# Mark review 'archive'
					puts "GV Review Alert: Not sending a review because user's review count has hit the max"
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
				# Handles people with paid plan_types
				plan_type = 'paid'

				# increment user's review
				review_count += 1
				user.save!

				# Send the review
				send_new_review(email, review, review_count, plan_type, run_now)

				# mark review sent
				review.status = 'sent'
				review.status_updated_at = Time.now
				review.save!
			end
		end
	end

	# my methods of madness
	def send_new_review(email, review, review_count, plan_type, run_now)
		comment = review.comment
		rating = review.rating.to_f
		source = review.source.name
		location = review.location.name
		location_link = review.url
		puts "GV Review Alert: Sending a review alert to #{location} to #{email}"
		if run_now == true
			NotifyMailer.delay.review_alert(email, comment, rating, source, location, location_link, review_count, plan_type)
		else
			NotifyMailer.delay({:run_at => 6.hours.from_now}).review_alert(email, comment, rating, source, location, location_link, review_count, plan_type)
		end
	end
end