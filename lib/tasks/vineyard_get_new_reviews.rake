require_relative '../vineyard/opentable.rb'
require_relative '../vineyard/yelp.rb'
require_relative '../vineyard/googleplus.rb'
require_relative '../vineyard/urbanspoon.rb'
require_relative '../vineyard/tripadvisor.rb'

namespace :vineyard do
	desc "Check All Locations for New Reviews Across All Sites"
	task 'get_new_reviews:all' => :environment do
		job_start_time = Time.now
		puts "Checking for new reviews across all review sites"

		parsers = Source.all
		parsers.each do |parser|
			parser_start_time = Time.now
			puts "Check for new reviews for #{parser.name}"
			Rake::Task["vineyard:get_new_reviews:all:by_parser"].reenable
			Rake::Task["vineyard:get_new_reviews:all:by_parser"].invoke(parser)
			puts "Total check time: #{((Time.now - parser_start_time)/60.0)} minutes"
		end

		puts "GV Review Alert: Checked for new reviews across all review sites"
		puts "GV Review Alert: Total check time: #{((Time.now - job_start_time)/60.0)} minutes"
	end

	desc 'Check for all reviews given a Parser'
	task 'get_new_reviews:all:by_parser', [:parser] => :environment do |t, args|
		if args[:parser]
			parser = args[:parser]
		else
			puts "Alert: A source/parser object is required for this task. Rake task terminated."
			next
		end

		puts "Find reviews for all locations who have #{parser.name.capitalize}"
		# TODO: 2.days.ago is so we have one day to manually check source_location_uris of urbanspoon and tripadvisor
		vines_older_than_two_days = parser.vines.where('created_at <= ?', 2.days.ago.beginning_of_day)

		vines_older_than_two_days.each do |vine|
		#parser.vines.each do |vine|
			location = vine.location
			Rake::Task['vineyard:get_new_reviews:all:by_location'].reenable
			Rake::Task['vineyard:get_new_reviews:all:by_location'].invoke(location, parser)
		end
	end

	desc 'Check for new reviews, for one location at a particular parser'
	task 'get_new_reviews:all:by_location', [:location, :parser] => :environment do |t, args|
		if args[:location] && args[:parser]
			location = args[:location]
			parser = args[:parser]
		else
			puts "Alert: Both a location and a source/parser object is required for this task. Rake task terminated."
			next
		end
		
		response = get_reviews(location, parser)

		if response.blank?
			puts "No new reviews added for #{location.name} at #{parser.name.capitalize}"
			next
		end

		add_new_reviews(response, location, parser)
	end

private

	def get_reviews(location, parser)
		puts "Finding reviews for #{location.name} at #{parser.name.capitalize}"
		reviews = location.reviews.where('source_id = ?', parser.id)

		# Instantiate new object of provided source/parser
		run = parser.name.capitalize.constantize.new
		
		if reviews.empty?
			run.get_new_reviews(location)
		else
			latest_five_reviews = get_last_five_reviews(location, parser)
			latest_review_date = latest_five_reviews.sort_by(&:post_date).reverse.first.post_date
			latest_comments = latest_five_reviews.map(&:comment)
			run.get_new_reviews(location, 
				:latest_review_date => latest_review_date, 
				:latest_comments => latest_comments)
		end
	end
	
	def get_last_five_reviews(location, parser)
		location.reviews.where('source_id = ?', parser.id).last(5)
	end

	def add_new_reviews(response, location, parser)
		review_count = 0
		response.each do |review|
			add_new_review(location, parser, review)
			review_count += 1
		end
		puts "GV Alert: Finished adding #{review_count} new reviews for: #{location.name} from #{parser.name.capitalize}"
	end

	def add_new_review(location, parser, review)
		Review.create(:location_id 		=> location.id,
						:source_id   		=> parser.id, 
					    :post_date   		=> review[:post_date],
					    :comment     		=> review[:comment],
					    :author	     		=> review[:author],
					    :author_url  		=> review[:author_url],
					    :rating      		=> review[:rating],
					    :rating_description => review[:rating_description],
					    :title       		=> review[:title],
					    :url         		=> review[:url],
					    :status				=> 'new',
					    :status_updated_at  => Time.now )

	end
end