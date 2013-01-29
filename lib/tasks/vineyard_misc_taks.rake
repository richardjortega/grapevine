# These tasks will handle various misc tasks associated
# with our vineyard system
namespace :vineyard do
	desc 'Run everything in sequence'
	task :harvest => :environment do
		# Check to verify if it's first of the month, if it is reset all user's review count to 0
		if Date.today
		end

		# Check for new source_location_uris for any locations that don't have any
		Rake::Task['get_source_location_uri:all'].reenable
		Rake::Task['get_source_location_uri:all'].invoke


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