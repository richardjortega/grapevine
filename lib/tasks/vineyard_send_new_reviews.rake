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
			
			# Ensure the location we are checking reviews for has an associating user
			if user.nil?
				puts "GV Review Alert: This location doesn't have any users associated, needs to be deleted or matched to a user."
				next
			end
			
			user_id = user.id
			email = user.email

			# Set args
			run_now = args[:run_now]

			# Change user's review_count to zero if nil
			user.review_count = 0 if user.review_count.nil?
		
			# Check user's subscription status first
			if user.subscription.status == true
				# Check user's plan
				# Handle active users that are on free plan
				if user.plan.identifier == 'gv_free'
					plan_type = 'free'
					if user.review_count <= 4
						# increment user's review
						user.review_count += 1
						user.save!

						# Send the review
						send_new_review(email, review, user.review_count, plan_type, run_now)
						
						# mark review sent
						review.status = 'sent'
						review.status_updated_at = Time.now
						review.save!

						# Alert us about users who have maxed out
						if user.review_count == 5
							puts "GV Review Alerts: #{email} has hit their max review count"
							DelayedKiss.record(email, 'User Hit Max Review Count', {'Location' => "#{location}"})
							NotifyMailer.delay.update_grapevine_team(user, "User has just hit their max review")
							NotifyMailer.delay({:run_at => 2.days.from_now}).reviews_maxed_alert(user)
						end
					else
						# Handles people who hit their max review count
						# increment user's review
						user.review_count += 1
						user.save!

						# Don't send the review
						# Mark review 'archive'
						puts "GV Review Alert: Not sending a review because user's review count has hit the max"
						review.status = 'archive'
						review.status_updated_at = Time.now
						review.save!
					end
				else
					# Handles active users that have paid and are not on free plan
					plan_type = 'paid'

					# increment user's review
					user.review_count += 1
					user.save!

					# Send the review
					send_new_review(email, review, user.review_count, plan_type, run_now)

					# mark review sent
					review.status = 'sent'
					review.status_updated_at = Time.now
					review.save!
				end
			else
				# Handles unpaid/canceled users
				# increment user's review
				user.review_count += 1
				user.save!

				# Don't send the review
				# Mark review as 'archive'
				puts "GV Review Alert: Not sending review to user because they are unpaid/canceled."
				review.status = 'archive'
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
		if run_now == true
			puts "GV Review Alert: Sending reviews at #{Time.now}"
			NotifyMailer.delay.review_alert(email, comment, rating, source, location, location_link, review_count, plan_type)
		else
			puts "GV Review Alert: Sending reviews at #{6.hours.from_now}"
			NotifyMailer.delay({:run_at => 6.hours.from_now}).review_alert(email, comment, rating, source, location, location_link, review_count, plan_type)
		end
	end
end