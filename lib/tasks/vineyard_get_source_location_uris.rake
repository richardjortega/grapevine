require_relative '../vineyard/opentable.rb'
require_relative '../vineyard/yelp.rb'
require_relative '../vineyard/googleplus.rb'
require_relative '../vineyard/urbanspoon.rb'
require_relative '../vineyard/tripadvisor.rb'

namespace :vineyard do
	
	desc 'Find all source_location_uris for all locations that do not have vines'
	task 'get_source_location_uri:all' => :environment do
		count = Location.all.count
		puts "There are #{count} locations we will check for source_location_uris"
		Location.all.each do |location|
			# Don't check this location if we've checked within the last 30 days
			next if location.uri_check_date
			
			# Make sure we don't overwrite existing urls, only find uris for locations without a corrresponding source
			existing_vines = []
			location.vines.each do |vine|
				existing_vines << vine.source.name
			end

			check_review_sites(existing_vines, location)
			set_check_date(location)
		end
		puts "Finished checking for all locations for any source_location_uris that may have been missing. Thank you, pwnage."
	end

	desc 'Find all source_location_uris for all locations that do not have vines, except ignore the last uri check date'
	task 'get_source_location_uri:all:ignore_check_date' => :environment do
		count = Location.all.count
		puts "There are #{count} locations we will check for source_location_uris"
		Location.all.each do |location|
			# Make sure we don't overwrite existing urls, only find uris for locations without a corrresponding source
			existing_vines = []
			location.vines.each do |vine|
				existing_vines << vine.source.name
			end

			check_review_sites(existing_vines, location)
			set_check_date(location)
		end
		puts "Finished checking for all locations for any source_location_uris that may have been missing. Thank you, pwnage."
	end

	desc 'Daily find for source_location_uris for all locations that do not have vines'
	task 'get_source_location_uri:daily_check' => :environment do
		count = Location.where('created_at >= ?', Date.yesterday.beginning_of_day).count
		puts "There are #{count} locations we will check for source_location_uris."
		next if count == 0
		Location.where('created_at >= ?', Date.yesterday.beginning_of_day).each do |location|
			# Don't check this location if we've checked within the last 30 days
			next if location.uri_check_date
			
			# Make sure we don't overwrite existing urls, only find uris for locations without a corrresponding source
			existing_vines = []
			location.vines.each do |vine|
				existing_vines << vine.source.name
			end

			check_review_sites(existing_vines, location)
			set_check_date(location)
		end
		puts "Finished checking for locations added from yesterday for any source_location_uris that may have been missing. Thank you, pwnage."
	end

	desc 'Find all source_location_uris for one location that does not have vines'
	task 'get_source_location_uri:one_for_all' => :environment do
		location = Location.find(ENV["LOCATION_ID"])

		# Make sure we don't overwrite existing urls, only find uris for locations without a corrresponding source
		existing_vines = []
		location.vines.each do |vine|
			existing_vines << vine.source.name
		end

		check_review_sites(existing_vines, location)
		set_check_date(location)
		puts "Finished checking for source_location_uris for #{location.name}. Thank you, pwnage."
	end


	desc 'Find Yelp ID# and associate it to Location: term, lat, long (Assumes 1st is right)'
	task 'get_source_location_uri:yelp', [:location_id, :term, :lat, :long] => :environment do |t, args|
		source = Source.find_by_name('yelp')
		source_id = source.id
		location_id = args[:location_id]
		term = args[:term]
		lat = args[:lat]
		long = args[:long]
		puts "Searching for Yelp ID using term: #{term}"
		run = Yelp.new
		source_location_uri = run.get_location_id(term, lat, long)
		next if source_location_uri.nil?
		unless source_location_uri ==  "Could not find any matching information"
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end

	desc 'Find Google ID# : term, lat, long (Assumes 1st is right)'
	task 'get_source_location_uri:google', [:location_id, :term, :lat, :long] => :environment do |t, args|
		source = Source.find_by_name('googleplus')
		source_id = source.id
		location_id = args[:location_id]
		term = args[:term]
		lat = args[:lat]
		long = args[:long]
		puts "Searching for Google ID using term: #{term}"
		run = Googleplus.new
		source_location_uri = run.get_location_id(term, lat, long)
		next if source_location_uri.nil?
		unless source_location_uri ==  "Could not find any matching information"
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end

	desc 'Find UrbanSpoon ID# : term, street_address, city, state, zip, lat, long'
	task 'get_source_location_uri:urbanspoon', [:location_id, :term, :street_address, :city, :state, :zip, :lat, :long] => :environment do |t, args|
		source = Source.find_by_name('urbanspoon')
		source_id = source.id
		args.with_defaults(:street_address => "", :city => "", :state => "", :zip => "")
		location_id = args[:location_id]
		term = args[:term]
		street_address = args[:street_address]
		city = args[:city]
		state = args[:state]
		zip = args[:zip]
		lat = args[:lat]
		long = args[:long]
		puts "Searching for UrbanSpoon ID using term: #{term}"
		run = Urbanspoon.new
		source_location_uri = run.get_location_id(term, street_address, city, state, zip, lat, long)
		next if source_location_uri.nil?
		unless source_location_uri ==  "Could not find any matching information"
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end

	desc 'Find TripAdvisor ID# : term, street_address, city, state, zip'
	task 'get_source_location_uri:tripadvisor', [:location_id, :term, :street_address, :city, :state, :zip] => :environment do |t, args|
		source = Source.find_by_name('tripadvisor')
		source_id = source.id
		args.with_defaults(:street_address => "", :city => "", :state => "", :zip => "")
		location_id = args[:location_id]
		term = args[:term]
		street_address = args[:street_address]
		city = args[:city]
		state = args[:state]
		zip = args[:zip]
		puts "Searching for TripAdvisor ID using term: #{term}"
		run = Tripadvisor.new
		source_location_uri = run.get_location_id(term, street_address, city, state, zip)
		next if source_location_uri.nil?
		unless source_location_uri ==  "Could not find any matching information"
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end

	desc 'Find OpenTable ID# : term, street_address, city, state, zip'
	task 'get_source_location_uri:opentable', [:location_id, :term, :street_address, :city, :state, :zip] => :environment do |t, args|
		source = Source.find_by_name('opentable')
		source_id = source.id
		args.with_defaults(:street_address => "", :city => "", :state => "", :zip => "")
		location_id = args[:location_id]
		term = args[:term]
		street_address = args[:street_address]
		city = args[:city]
		state = args[:state]
		zip = args[:zip]
		puts "Searching for OpenTable ID using term: #{term}"
		run = Opentable.new
		source_location_uri = run.get_location_id(term, street_address, city, state, zip)
		next if source_location_uri.nil?
		unless source_location_uri ==  "Could not find any matching information"
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end

	# Methods!!
	def add_new_vine(source, location_id, source_location_uri, term)
		return if source_location_uri.nil?
		Vine.create(:source_id 			   => source.id, 
		 			:location_id 		   => location_id, 
					:source_location_uri   => source_location_uri)
		puts "Added #{source.name} source_location_uri '#{source_location_uri}' to #{term}"	
	end

	def check_review_sites(existing_vines, location)

		location_id = location.id
		term = location.name
		street_address = location.street_address
		city = location.city
		state = location.state
		zip = location.zip
		lat = location.lat.to_f
		long = location.long.to_f

		unless existing_vines.include?('yelp')
			puts "Didn't find a Yelp source_location_uri for #{term}, finding it now..."			
			Rake::Task['vineyard:get_source_location_uri:yelp'].reenable
			Rake::Task['vineyard:get_source_location_uri:yelp'].invoke(location_id, term, lat, long)
		end

		unless existing_vines.include?('googleplus')
			puts "Didn't find a Google source_location_uri for #{term}, finding it now..."			
			Rake::Task['vineyard:get_source_location_uri:google'].reenable
			Rake::Task['vineyard:get_source_location_uri:google'].invoke(location_id, term, lat, long)
		end

		unless existing_vines.include?('urbanspoon')
			puts "Didn't find a UrbanSpoon source_location_uri for #{term}, finding it now..."			
			Rake::Task['vineyard:get_source_location_uri:urbanspoon'].reenable
			Rake::Task['vineyard:get_source_location_uri:urbanspoon'].invoke(location_id, term, street_address, city, state, zip, lat, long)
		end

		unless existing_vines.include?('tripadvisor')
			puts "Didn't find a TripAdvisor source_location_uri for #{term}, finding it now..."			
			Rake::Task['vineyard:get_source_location_uri:tripadvisor'].reenable
			Rake::Task['vineyard:get_source_location_uri:tripadvisor'].invoke(location_id, term, street_address, city, state, zip)
		end

		unless existing_vines.include?('opentable')
			puts "Didn't find a OpenTable source_location_uri for #{term}, finding it now..."			
			Rake::Task['vineyard:get_source_location_uri:opentable'].reenable
			Rake::Task['vineyard:get_source_location_uri:opentable'].invoke(location_id, term, street_address, city, state, zip)
		end
	end

	def set_check_date(location)
		location.update_column(:uri_check_date, Date.today)
	end


end	