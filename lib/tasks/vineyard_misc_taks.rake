# These tasks will handle various misc tasks associated
# with our vineyard system
namespace :vineyard do
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
end