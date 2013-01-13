require_relative '../vineyard/opentable.rb'
require_relative '../vineyard/yelp.rb'
require_relative '../vineyard/googleplus.rb'
require_relative '../vineyard/urbanspoon.rb'
require_relative '../vineyard/tripadvisor.rb'

namespace :get_source_location_uri do
	desc 'Find all source_location_uri for all locations that do not have vines'
	task :all => :environment do
		Location.all.each do |location|
			location_id = location.id
			term = location.name
			street_address = location.street_address
			city = location.city
			state = location.state
			zip = location.zip
			lat = location.lat.to_f
			long = location.long.to_f

			# Make sure we don't overwrite existing urls, only find uris for locations without a corrresponding source
			existing_vines = []
			location.vines.each do |vine|
				existing_vines << vine.source.name
			end

			unless existing_vines.include?('yelp')
				puts "Didn't find a Yelp source_location_uri for #{term}, finding it now..."			
				Rake::Task['get_source_location_uri:yelp'].reenable
				Rake::Task['get_source_location_uri:yelp'].invoke(location_id, term, lat, long)
			end

			unless existing_vines.include?('google')
				puts "Didn't find a Google source_location_uri for #{term}, finding it now..."			
				Rake::Task['get_source_location_uri:google'].reenable
				Rake::Task['get_source_location_uri:google'].invoke(location_id, term, lat, long)
			end

			unless existing_vines.include?('urbanspoon')
				puts "Didn't find a UrbanSpoon source_location_uri for #{term}, finding it now..."			
				Rake::Task['get_source_location_uri:urbanspoon'].reenable
				Rake::Task['get_source_location_uri:urbanspoon'].invoke(location_id, term, street_address, city, state, zip)
			end

			unless existing_vines.include?('tripadvisor')
				puts "Didn't find a TripAdvisor source_location_uri for #{term}, finding it now..."			
				Rake::Task['get_source_location_uri:tripadvisor'].reenable
				Rake::Task['get_source_location_uri:tripadvisor'].invoke(location_id, term, street_address, city, state, zip)
			end

			unless existing_vines.include?('opentable')
				puts "Didn't find a OpenTable source_location_uri for #{term}, finding it now..."			
				Rake::Task['get_source_location_uri:opentable'].reenable
				Rake::Task['get_source_location_uri:opentable'].invoke(location_id, term, street_address, city, state, zip)
			end

			puts "Finished checking all locations for any source_location_uris that may have been missing. Thank you, pwnage."
		end
	end


	desc 'Find Yelp ID# and associate it to Location: term, lat, long (Assumes 1st is right)'
	task :yelp, [:location_id, :term, :lat, :long] => :environment do |t, args|
		source = Source.find_by_name('yelp')
		source_id = source.id
		location_id = args[:location_id]
		term = args[:term]
		lat = args[:lat]
		long = args[:long]
		puts "Searching for Yelp ID using term: #{term}"
		run = Yelp.new
		source_location_uri = run.get_location_id(term, lat, long)
		unless source_location_uri ==  "Could not find any matching information"
			new_vine = Vine.new(:source_id 			   => source_id, 
					 			:location_id 		   => location_id, 
								:source_location_uri   => source_location_uri)
			new_vine.save!
		end
		puts "Added Yelp source_location_uri '#{source_location_uri}' to #{term}"	

	end

	desc 'Find Google ID# : term, lat, long (Assumes 1st is right)'
	task :google, [:location_id, :term, :lat, :long] => :environment do |t, args|
		source = Source.find_by_name('googleplus')
		source_id = source.id
		location_id = args[:location_id]
		term = args[:term]
		lat = args[:lat]
		long = args[:long]
		puts "Searching for Google ID using term: #{term}"
		run = Google.new
		source_location_uri = run.get_location_id(term, lat, long)
		unless source_location_uri ==  "Could not find any matching information"
			new_vine = Vine.new(:source_id 			   => source_id, 
					 			:location_id 		   => location_id, 
								:source_location_uri   => source_location_uri)
			new_vine.save!
		end
		puts "Added Google source_location_uri '#{source_location_uri}' to #{term}"	
	end

	desc 'Find UrbanSpoon ID# : term, street_address, city, state, zip (Assumes 1st is right)'
	task :urbanspoon, [:location_id, :term, :street_address, :city, :state, :zip] => :environment do |t, args|
		source = Source.find_by_name('urbanspoon')
		source_id = source.id
		location_id = args[:location_id]
		term = args[:term]
		street_address = args[:street_address]
		city = args[:city]
		state = args[:state]
		zip = args[:zip]
		puts "Searching for UrbanSpoon ID using term: #{term}"
		run = UrbanSpoon.new
		source_location_uri = run.get_location_id(term, street_address, city, state, zip)
		unless source_location_uri ==  "Could not find any matching information"
			new_vine = Vine.new(:source_id 			   => source_id, 
					 			:location_id 		   => location_id, 
								:source_location_uri   => source_location_uri)
			new_vine.save!
		end
		puts "Added UrbanSpoon source_location_uri '#{source_location_uri}' to #{term}"	
	end

	desc 'Find TripAdvisor ID# : term, street_address, city, state, zip (Assumes 1st is right)'
	task :tripadvisor, [:location_id, :term, :street_address, :city, :state, :zip] => :environment do |t, args|
		source = Source.find_by_name('tripadvisor')
		source_id = source.id
		location_id = args[:location_id]
		term = args[:term]
		street_address = args[:street_address]
		city = args[:city]
		state = args[:state]
		zip = args[:zip]
		puts "Searching for TripAdvisor ID using term: #{term}"
		run = TripAdvisor.new
		source_location_uri = run.get_location_id(term, street_address, city, state, zip)
		unless source_location_uri ==  "Could not find any matching information"
			new_vine = Vine.new(:source_id 			   => source_id, 
					 			:location_id 		   => location_id, 
								:source_location_uri   => source_location_uri)
			new_vine.save!
		end
		puts "Added TripAdvisor source_location_uri '#{source_location_uri}' to #{term}"	
	end

	desc 'Find OpenTable ID# : term, street_address, city, state, zip (Assumes 1st is right)'
	task :opentable, [:location_id, :term, :street_address, :city, :state, :zip] => :environment do |t, args|
		source = Source.find_by_name('opentable')
		source_id = source.id
		location_id = args[:location_id]
		term = args[:term]
		street_address = args[:street_address]
		city = args[:city]
		state = args[:state]
		zip = args[:zip]
		puts "Searching for OpenTable ID using term: #{term}"
		run = OpenTable.new
		source_location_uri = run.get_location_id(term, street_address, city, state, zip)
		unless source_location_uri ==  "Could not find any matching information"
			new_vine = Vine.new(:source_id 			   => source_id, 
					 			:location_id 		   => location_id, 
								:source_location_uri   => source_location_uri)
			new_vine.save!
		end
		puts "Added OpenTable source_location_uri '#{source_location_uri}' to #{term}"	
	end
end

namespace :get_new_reviews do
	desc "Check All Locations for New Reviews Across All Sites"
	task :all => :environment do
		job_start_time = Time.now
		puts "Checking for new reviews across all review sites"
		
		opentable_start_time = Time.now
		puts "Checking for new reviews at OpenTable"
		Rake::Task['get_new_reviews:opentable'].reenable
		Rake::Task['get_new_reviews:opentable'].invoke
		puts "Total check time: #{((Time.now - opentable_start_time)/60.0)} minutes"

		yelp_start_time = Time.now
		puts "Checking for new reviews at Yelp"
		Rake::Task['get_new_reviews:yelp'].reenable
		Rake::Task['get_new_reviews:yelp'].invoke
		puts "Total check time: #{((Time.now - yelp_start_time)/60.0)} minutes"

		google_start_time = Time.now
		puts "Checking for new reviews at Google"
		Rake::Task['get_new_reviews:google'].reenable
		Rake::Task['get_new_reviews:google'].invoke
		puts "Total check time: #{((Time.now - google_start_time)/60.0)} minutes"

		tripadvisor_start_time = Time.now
		puts "Checking for new reviews at TripAdvisor"
		Rake::Task['get_new_reviews:tripadvisor'].reenable
		Rake::Task['get_new_reviews:tripadvisor'].invoke
		puts "Total check time: #{((Time.now - tripadvisor_start_time)/60.0)} minutes"

		opentable_start_time = Time.now
		puts "Checking for new reviews at UrbanSpoon"
		Rake::Task['get_new_reviews:urbanspoon'].reenable
		Rake::Task['get_new_reviews:urbanspoon'].invoke
		puts "Total check time: #{((Time.now - opentable_start_time)/60.0)} minutes"

		puts "Finished checking for new reviews across all review sites"
		puts "Total check time: #{((Time.now - job_start_time)/60.0)} minutes"
	end
	
	desc "Check Yelp for new reviews"
	task :yelp => :environment do
		puts "Getting all associated source_location_uris of Yelp"
		source = Source.find_by_name('yelp')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.source.reviews
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
			reviews = vine.source.reviews
			if reviews.empty?
				last_30_days_ago = Date.today - 30
				latest_review = {:post_date => last_30_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{location.name}"
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
	task :google => :environment do
		puts "Getting all associated source_location_uris of Google"
		source = Source.find_by_name('googleplus')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.source.reviews
			if reviews.empty?
				last_30_days_ago = Date.today - 30
				latest_review = {:post_date => last_30_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{location.name}"
			run = Google.new
			response = run.get_new_reviews(latest_review, source_location_uri)
			review_count = 0
			response.each do |review|
				new_review = Review.new(:location_id 		=> location.id,
										:source_id   		=> source.id, 
									    :post_date   		=> review[:post_date],
									    :comment     		=> review[:comment],
									    :author	     		=> review[:author],
									    :author_url  		=> review[:author_url],
									    :rating      		=> review[:rating],
									    :rating_description => review[:rating_description],
									    :title       		=> review[:title],
									    :url         		=> review[:url] )
				new_review.save!
				review_count += 1
			end
			puts "Finished adding #{review_count} new reviews for: #{location.name}"
		end

	end

	desc "Check UrbanSpoon for new reviews"
	task :urbanspoon => :environment do
		puts "Getting all associated source_location_uris of UrbanSpoon"
		source = Source.find_by_name('urbanspoon')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.source.reviews
			if reviews.empty?
				last_30_days_ago = Date.today - 30
				latest_review = {:post_date => last_30_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{location.name}"
			run = UrbanSpoon.new
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

	desc "Check TripAdvisor for new reviews"
	task :tripadvisor => :environment do
		puts "Getting all associated source_location_uris of TripAdvisor"
		source = Source.find_by_name('tripadvisor')
		source_vines = source.vines
		source_vines.each do |vine|
			source_location_uri = vine.source_location_uri
			location = vine.location
			reviews = vine.source.reviews
			if reviews.empty?
				last_30_days_ago = Date.today - 30
				latest_review = {:post_date => last_30_days_ago, :comment => '' }
			else
				last_review = reviews.order('post_date DESC').first
				latest_review = {:post_date => last_review[:post_date], :comment => last_review[:comment]}
			end
			puts "Searching for new reviews at: #{location.name}"
			run = TripAdvisor.new
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

end