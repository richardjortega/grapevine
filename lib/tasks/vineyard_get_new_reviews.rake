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
			Rake::Task["vineyard:get_new_reviews:#{parser.name}"].reenable
			Rake::Task["vineyard:get_new_reviews:#{parser.name}"].invoke
			puts "Total check time: #{((Time.now - parser_start_time)/60.0)} minutes"
		end

		puts "GV Review Alert: Checked for new reviews across all review sites"
		puts "GV Review Alert: Total check time: #{((Time.now - job_start_time)/60.0)} minutes"
	end

	# Individual get_new_reviews rake calls

	desc 'Check for new reviews, for one location at a particular source'
	task 'get_new_reviews:for_location', [:location, :source] => :environment do |t, args|
		if args[:location]
			location = args[:location]
		else
			puts "Alert: A location object is required for this task"
			next
		end

		if args[:source]
			source = args[:source]
		else
			puts "Alert: A source object is required for this task"
			next
		end

		reviews = location.reviews.where('source_id = ?', source.id)
		
		# Instantiate new object of provided source
		puts "Finding reviews for #{location.name} at #{source.name.capitalize}"
		run = source.name.capitalize.constantize.new
		response = if reviews.empty?
			run.get_new_reviews(location)
		else
			latest_five_reviews = get_last_five_reviews(location, :source => source)
			latest_review_date = latest_five_reviews.sort_by(&:post_date).reverse.first.post_date
			latest_comments = latest_five_reviews.map(&:comment)
			run.get_new_reviews(location, 
				:latest_review_date => latest_review_date, 
				:latest_comments => latest_comments)
		end
		
		# Error handling of nil and empty response values
		if response.nil?
			puts "No new reviews added for #{location.name} at #{source.name.capitalize}"
			next
		end
		if response.empty?
			puts "No new reviews added for #{location.name} at #{source.name.capitalize}"
			next
		end

		add_new_reviews(response, location, source)
	end

	desc 'Check for all reviews given a Parser'
	task 'get_new_reviews:all:by_parser', [:source] => :environment do |t, args|
		if args[:location]
			location = args[:location]
		else
			puts "Alert: A location object is required for this task"
			next
		end
	end
	
	desc "Check Yelp for new reviews"
	task 'get_new_reviews:yelp' => :environment do
		puts "Find reviews for all locations who have Yelp"
		source = Source.find_by_name('yelp')
		source_vines = source.vines
		source_vines.each do |vine|
			location = vine.location
			Rake::Task['vineyard:get_new_reviews:for_location'].reenable
			Rake::Task['vineyard:get_new_reviews:for_location'].invoke(location, source)
		end
	end

	desc "Check UrbanSpoon for new reviews"
	task 'get_new_reviews:urbanspoon' => :environment do
		puts "Find reviews for all locations who have UrbanSpoon"
		source = Source.find_by_name('urbanspoon')
		source_vines = source.vines
		source_vines.each do |vine|
			location = vine.location
			Rake::Task['vineyard:get_new_reviews:for_location'].reenable
			Rake::Task['vineyard:get_new_reviews:for_location'].invoke(location, source)
		end
	end

	desc "Check Google Plus for new reviews"
	task 'get_new_reviews:googleplus' => :environment do
		puts "Find reviews for all locations who have Google Plus"
		source = Source.find_by_name('googleplus')
		source_vines = source.vines
		source_vines.each do |vine|
			location = vine.location
			Rake::Task['vineyard:get_new_reviews:for_location'].reenable
			Rake::Task['vineyard:get_new_reviews:for_location'].invoke(location, source)
		end
	end

	desc "Check TripAdvisor for new reviews"
	task 'get_new_reviews:tripadvisor' => :environment do
		puts "Find reviews for all locations who have TripAdvisor"
		source = Source.find_by_name('tripadvisor')
		source_vines = source.vines
		source_vines.each do |vine|
			location = vine.location
			Rake::Task['vineyard:get_new_reviews:for_location'].reenable
			Rake::Task['vineyard:get_new_reviews:for_location'].invoke(location, source)
		end
	end

	desc "Check OpenTable for new reviews"
	task 'get_new_reviews:opentable' => :environment do
		puts "Find reviews for all locations who have OpenTable"
		source = Source.find_by_name('opentable')
		source_vines = source.vines
		source_vines.each do |vine|
			location = vine.location
			Rake::Task['vineyard:get_new_reviews:for_location'].reenable
			Rake::Task['vineyard:get_new_reviews:for_location'].invoke(location, source)
		end
	end
	
	def get_last_five_reviews(location, options = {})
		# Pass in the source object into options hash for last 5 reviews by specific source
		if options[:source]
			location.reviews.where('source_id = ?', options[:source].id).last(5)
		else
			location.reviews.last(5)
		end
	end

	def add_new_review(location, source, review)
		Review.create(:location_id 		=> location.id,
						:source_id   		=> source.id, 
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

	def add_new_reviews(response, location, source)
		review_count = 0
		response.each do |review|
			add_new_review(location, source, review)
			review_count += 1
		end
		puts "GV Alert: Finished adding #{review_count} new reviews for: #{location.name} from #{source.name.capitalize}"
	end

end