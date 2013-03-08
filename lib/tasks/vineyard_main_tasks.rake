# These tasks will handle various misc tasks associated
# with our vineyard system
namespace :vineyard do
	desc 'Run everything in sequence'
	task :harvest => :environment do
		# Check to verify if it's first of the month, if it is reset all user's review count to 0
		if Date.today == Date.today.beginning_of_month
			Rake::Task['vineyard:reset_users_review_counts'].reenable
			Rake::Task['vineyard:reset_users_review_counts'].invoke
			puts "GV Review Alert: Reset all users' review counts to 0 for the start of the month"
		end

		# Daily reseting of API tallies
		Rake::Task['vineyard:reset_daily_api_count'].reenable
		Rake::Task['vineyard:reset_daily_api_count'].invoke
		puts "GV Review Alert: Reseted Daily API Count"

		# Check for new source_location_uris for any locations that don't have any
		# You should run 'vineyard:get_source_location_uri:all' the first time on the DB, then daily check thereafter
		Rake::Task['vineyard:get_source_location_uri:daily_check'].reenable
		Rake::Task['vineyard:get_source_location_uri:daily_check'].invoke
		puts "GV Review Alert: Matched newly added locations (#{Date.yesterday}) to likely source_location_uris"

		# Get new reviews for all the locations
		Rake::Task['vineyard:get_new_reviews:all'].reenable
		Rake::Task['vineyard:get_new_reviews:all'].invoke
		puts "GV Review Alert: Searched for all new reviews for #{Date.yesterday}"

		# Send all new reviews to corresponding location's user email
		Rake::Task['vineyard:send_new_reviews'].reenable
		Rake::Task['vineyard:send_new_reviews'].invoke

	end

	desc 'Reset daily api count field for each source, add daily count to total count'
	task :reset_daily_api_count => :environment do
		Source.all.each do |source|
			next if source.api_count_daily.nil?
			source_id = source.id
			api_count_daily = source.api_count_daily
			Source.update_counters(source_id, :api_count_all_time => api_count_daily)
			puts "Updated #{source.name} api_count_all_time by #{api_count_daily}."
			source.api_count_daily = 0
			puts "Reset #{source.name} api_count_daily back to 0."
			source.save!
		end
	end

	desc "Reset all user's review count to 0 if first of the month"
	task :reset_users_review_counts => :environment do
		User.all.each do |user|
			user.review_count = 0
			user.save!
		end
	end
end