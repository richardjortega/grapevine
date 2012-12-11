require_relative '../vineyard/opentable.rb'
require_relative '../vineyard/yelp.rb'
require_relative '../vineyard/googleplus.rb'
require_relative '../vineyard/urbanspoon.rb'
# require_relative "../../app/models/review"
require_relative "../../app/models/location"


namespace :crawl do
	desc "Check All Locations for New Reviews Across All Sites"
	task :all => :environment do
		zinc = Location.find('13')
		# Check OpenTable
		Rake::Task['crawl:opentable'].reenable
		Rake::Task['crawl:opentable'].invoke(zinc)
	end
	

	desc "Check OpenTable for new reviews"
	task :opentable => :environment do
		#Location.all.each do |location|
			#location_id = location.source('opentable').matchingid

			#for testing
			location_id = '86449'
			latest_review = {:post_date => '11/29/2012', :comment => 'asdfad'}

			run = OpenTable.new location_id
			response = run.get_new_reviews latest_review
			puts response
		#end
	end


	desc "Check Yelp for new reviews"
	task :yelp => :environment do
		# Location.all.each do |location|
			# location_id = location.source('yelp').matchingid

			# for testing
			latest_review = {:post_date => '01/29/2012', :comment => 'asdfad'}
			location_id = 'rosarios-mexican-cafe-y-cantina-san-antonio'

			run = Yelp.new location_id
			response = run.get_new_reviews latest_review
			puts response
		# end
	end

	desc "Check GooglePlus for new reviews"
	task :googleplus => :environment do
		# Location.all.each do |location|
			# location_id = location.source('opentable').matchingid

			# for testing
			latest_review = {:post_date => '01/29/2012', :comment => 'asdfad'}
			location_id = 'CnRmAAAAGg321uK8xOiQRZguEZvxKwZXqwzShD1Mx5rW7bolqViOIC4anBbtDrqZDaJ2KSdrEoDgdOhxuwtwI35QlDEgvhFmkPek-MDkV3Gj8ZGMz-wQlAWjbiSIjeVu8pB6Yy8iE5dMIK0fLl4e4Mh0Lu9ihhIQwUApDK4XMZazepOYt6XJQBoUgvF1h4j1OCCNCfVnRmcpbvJwIpE'

			run = GooglePlus.new location_id
			response = run.get_new_reviews latest_review
			puts response
		# end
	end

	desc "Check UrbanSpoon for new reviews"
	## TODO - reviews still need to be averaged.
	task :urbanspoon => :environment do
		# Location.all.each do |location|
			# location_id = location.source('opentable').matchingid

			# for testing
			latest_review = {:post_date => '11/15/2012', :comment => 'asdfad'}
			location_id = 'r/39/432003/restaurant/Midtown/Sams-Burger-Joint-San-Antonio'
			job_start_time = Time.now
			puts "Starting job: #{location_id}"
			run = UrbanSpoon.new location_id
			response = run.get_new_reviews latest_review
			puts response
			puts "Finished job in #{Time.now - job_start_time} seconds"
		# end
	end

end