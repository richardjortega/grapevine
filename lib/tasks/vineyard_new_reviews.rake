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
		
		opentable_start_time = Time.now
		puts "Checking for new reviews at OpenTable"
		Rake::Task['vineyard:get_new_reviews:opentable'].reenable
		Rake::Task['vineyard:get_new_reviews:opentable'].invoke
		puts "Total check time: #{((Time.now - opentable_start_time)/60.0)} minutes"

		yelp_start_time = Time.now
		puts "Checking for new reviews at Yelp"
		Rake::Task['vineyard:get_new_reviews:yelp'].reenable
		Rake::Task['vineyard:get_new_reviews:yelp'].invoke
		puts "Total check time: #{((Time.now - yelp_start_time)/60.0)} minutes"

		google_start_time = Time.now
		puts "Checking for new reviews at Google"
		Rake::Task['vineyard:get_new_reviews:google'].reenable
		Rake::Task['vineyard:get_new_reviews:google'].invoke
		puts "Total check time: #{((Time.now - google_start_time)/60.0)} minutes"

		tripadvisor_start_time = Time.now
		puts "Checking for new reviews at TripAdvisor"
		Rake::Task['vineyard:get_new_reviews:tripadvisor'].reenable
		Rake::Task['vineyard:get_new_reviews:tripadvisor'].invoke
		puts "Total check time: #{((Time.now - tripadvisor_start_time)/60.0)} minutes"

		opentable_start_time = Time.now
		puts "Checking for new reviews at UrbanSpoon"
		Rake::Task['vineyard:get_new_reviews:urbanspoon'].reenable
		Rake::Task['vineyard:get_new_reviews:urbanspoon'].invoke
		puts "Total check time: #{((Time.now - opentable_start_time)/60.0)} minutes"

		puts "Finished checking for new reviews across all review sites"
		puts "Total check time: #{((Time.now - job_start_time)/60.0)} minutes"
	end
	
	desc "Check Yelp for new reviews"
	task 'get_new_reviews:yelp' => :environment do
		puts "Getting all associated source_location_uris of Yelp"
		source = Source.find_by_name('yelp')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.location.reviews.where('source_id = ?', source.id)
			if reviews.empty?
				last_3_days_ago = Date.today - 3
				latest_review = {:post_date => last_3_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{source_location_uri}"
			run = Yelp.new
			response = run.get_new_reviews(latest_review, source_location_uri)
			if response.empty?
				puts "Didn't find any new reviews for #{location.name}"
				next
			end
			review_count = 0
			next if response.nil?
			response.each do |review|
				add_new_review(location, source, review)
				review_count += 1
			end
			puts "Finished adding #{review_count} new reviews for: #{location.name}"
		end
	end
	
	desc "Check OpenTable for new reviews"
	task 'get_new_reviews:opentable' => :environment do
		puts "Getting all associated source_location_uris of OpenTable"
		source = Source.find_by_name('opentable')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.location.reviews.where('source_id = ?', source.id)
			if reviews.empty?
				last_3_days_ago = Date.today - 3
				latest_review = {:post_date => last_3_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{location.name}"
			run = OpenTable.new
			response = run.get_new_reviews(latest_review, source_location_uri)
			review_count = 0
			next if response.nil?
			response.each do |review|
				add_new_review(location, source, review)
				review_count += 1
			end
			puts "Finished adding #{review_count} new reviews for: #{location.name}"
		end
	end

	desc "Check GooglePlus for new reviews"
	task 'get_new_reviews:google' => :environment do
		puts "Getting all associated source_location_uris of Google"
		source = Source.find_by_name('googleplus')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.location.reviews.where('source_id = ?', source.id)
			if reviews.empty?
				last_3_days_ago = Date.today - 3
				latest_review = {:post_date => last_3_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{location.name}"
			run = Google.new
			response = run.get_new_reviews(latest_review, source_location_uri)
			review_count = 0
			next if response.nil?
			response.each do |review|
				add_new_review(location, source, review)
				review_count += 1
			end
			puts "Finished adding #{review_count} new reviews for: #{location.name}"
		end

	end

	desc "Check UrbanSpoon for new reviews"
	task 'get_new_reviews:urbanspoon' => :environment do
		puts "Getting all associated source_location_uris of UrbanSpoon"
		source = Source.find_by_name('urbanspoon')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.location.reviews.where('source_id = ?', source.id)
			if reviews.empty?
				last_3_days_ago = Date.today - 3
				latest_review = {:post_date => last_3_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{location.name}"
			run = UrbanSpoon.new
			response = run.get_new_reviews(latest_review, source_location_uri)
			review_count = 0
			next if response.nil?
			response.each do |review|
				add_new_review(location, source, review)
				review_count += 1
			end
			puts "Finished adding #{review_count} new reviews for: #{location.name}"
		end
	end

	desc "Check TripAdvisor for new reviews"
	task 'get_new_reviews:tripadvisor' => :environment do
		puts "Getting all associated source_location_uris of TripAdvisor"
		source = Source.find_by_name('tripadvisor')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.location.reviews.where('source_id = ?', source.id)
			if reviews.empty?
				last_3_days_ago = Date.today - 3
				latest_review = {:post_date => last_3_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{location.name}"
			run = TripAdvisor.new
			response = run.get_new_reviews(latest_review, source_location_uri)
			review_count = 0
			next if response.nil?
			response.each do |review|
				add_new_review(location, source, review)
				review_count += 1
			end
			puts "Finished adding #{review_count} new reviews for: #{location.name}"
		end
	end

	# Methods!!!

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

end