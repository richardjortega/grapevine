require_relative '../vineyard/opentable.rb'
require_relative '../vineyard/yelp.rb'
require_relative '../vineyard/googleplus.rb'
require_relative '../vineyard/urbanspoon.rb'
require_relative '../vineyard/tripadvisor.rb'
# require_relative "../../app/models/review"
require_relative "../../app/models/location"

namespace :get_vine do
	desc 'Find Yelp ID# : term, lat, long'
	task :yelp, [:term, :lat, :long] => :environment do |t, args|
		term = args[:term]
		lat = args[:lat]
		long = args[:long]
		puts "Searching for Yelp ID using term: #{term}"
		run = Yelp.new
		response = run.get_location_id(term, lat, long)
		puts response['businesses'][0]['id']
	end
end

namespace :get_new_reviews do
	desc "Check All Locations for New Reviews Across All Sites"
	task :all => :environment do
		zinc = Location.find('13')
		# Check OpenTable
		Rake::Task['crawl:opentable'].reenable
		Rake::Task['crawl:opentable'].invoke(zinc)
	end
	
	desc "Check Yelp for new reviews"
	task :yelp => :environment do
		puts "Getting all associated source_location_uris of Yelp"
		source = Source.find_by_name('yelp')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = location.reviews
			if reviews.empty?
				last_30_days_ago = Date.today - 30
				latest_review = {:post_date => last_30_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{source_location_uri}"
			run = Yelp.new
			response = run.get_new_reviews(latest_review, source_location_uri)

			review_count = 0
			response.each do |review|
				new_review = Review.new(:location_id => location.id,
										:source_id   => source.id, 
									    :post_date   => review[:post_date],
									    :comment     => review[:comment],
									    :author	     => review[:author],
									    :rating      => review[:rating],
									    :url         => review[:url] )
				new_review.save!
				review_count += 1
			end
			puts "Finished adding #{review_count} new reviews for: #{location.name}"
		end
	end
	
	desc "Check OpenTable for new reviews"
	task :opentable => :environment do
		puts "Getting all associated source_location_uris of OpenTable"
		source = Source.find_by_name('opentable')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = location.reviews
			if reviews.empty?
				last_30_days_ago = Date.today - 30
				latest_review = {:post_date => last_30_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{source_location_uri}"
			run = OpenTable.new
			response = run.get_new_reviews(latest_review, source_location_uri)
			review_count = 0
			response.each do |review|
				new_review = Review.new(:location_id => location.id,
										:source_id   => source.id, 
									    :post_date   => review[:post_date],
									    :comment     => review[:comment],
									    :author	     => review[:author],
									    :rating      => review[:rating],
									    :title       => review[:title],
									    :url         => review[:url] )
				new_review.save!
				review_count += 1
			end
			puts "Finished adding #{review_count} new reviews for: #{location.name}"
		end
	end

	desc "Check GooglePlus for new reviews"
	task :googleplus => :environment do
		# Location.all.each do |location|
			# location_id = location.source('googelplus').matchingid

			# for testing
			latest_review = {:post_date => '01/29/2012', :comment => 'asdfad'}
			location_id = 'CnRmAAAAGg321uK8xOiQRZguEZvxKwZXqwzShD1Mx5rW7bolqViOIC4anBbtDrqZDaJ2KSdrEoDgdOhxuwtwI35QlDEgvhFmkPek-MDkV3Gj8ZGMz-wQlAWjbiSIjeVu8pB6Yy8iE5dMIK0fLl4e4Mh0Lu9ihhIQwUApDK4XMZazepOYt6XJQBoUgvF1h4j1OCCNCfVnRmcpbvJwIpE'

			run = GooglePlus.new location_id
			response = run.get_new_reviews latest_review
			puts response
		# end
	end

	desc "Check UrbanSpoon for new reviews"
	task :urbanspoon => :environment do
		# Location.all.each do |location|
			# location_id = location.source('urbanspoon').matchingid

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

	desc "Check TripAdvisor for new reviews"
	task :tripadvisor => :environment do
		#Location.all.each do |location|
			#location_id = location.source('tripadvisor').matchingid

			#for testing
			location_id = 'Restaurant_Review-g60956-d437237-Reviews-Las_Canarias_Restaurant-San_Antonio_Texas.html'
			latest_review = {:post_date => '11/29/2012', :comment => 'asdfad'}

			run = TripAdvisor.new location_id
			response = run.get_new_reviews latest_review
			puts response
		#end
	end

end