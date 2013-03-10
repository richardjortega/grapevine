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

	#########
	desc 'Daily find for source_location_uris for all locations that do not have vines'
	task 'get_source_location_uri:daily_check' => :environment do
		new_locations = Location.where('created_at >= ?', Date.yesterday.beginning_of_day)
		count = new_locations.count
		puts "GV Alert: There are #{count} locations we will check for source_location_uris."
		next if count == 0
		new_locations.each do |location|
			# Don't check this location if we've checked already
			next if location.uri_check_date

			check_review_sites(location)
			set_check_date(location)
		end
		puts "Finished checking for locations added from yesterday for any source_location_uris that may have been missing. Thank you, pwnage."
	end
	##########

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

	desc 'Find source_location_uri by parser given a location object'
	task 'get_source_location_uri', [:location, :parser] => :environment do |t, args|
		if args[:location] && args[:parser]
			location = args[:location]
			parser = args[:parser]
		else
			puts "Alert: Both a location and a source/parser object is required for this task. Rake task terminated."
			next
		end

		source_location_uri = get_vine(location, parser)
		next if source_location_uri.nil?
		unless source_location_uri ==  "Could not find any matching information"
			add_new_vine(source, location, source_location_uri)
		end
	end

	desc 'Find source_location_uri by IDs given, for both parser and location'
	task 'get_source_location_uri:by_id', [:location_id, :parser_id] => :environment do |t, args|
		if args[:location_id] && args[:parser_id]
			location = Location.find(args[:location_id])
			parser = Source.find(args[:parser_id])
		else
			puts "Alert: Both a location and a source/parser object is required for this task. Rake task terminated."
			next
		end

		source_location_uri = get_vine(location, parser)
		if source_location_uri.nil?
			puts "Nothing found."
			next
		end
		puts "Found source_location_uri for #{location.name}: #{source_location_uri}"
	end


	# Methods!!
	def add_new_vine(source, location, source_location_uri)
		return if source_location_uri.nil?
		Vine.create(:source_id 			   => source.id, 
		 			:location_id 		   => location.id, 
					:source_location_uri   => source_location_uri)
		puts "Added #{source.name} source_location_uri '#{source_location_uri}' to #{location.name}"	
	end

	def check_review_sites(location)
		found_vines = find_existing_vines(location)

		parsers = Source.all
		parsers.each do |parser|
			next unless parser.get_location_id_status?
			next if found_vines.include?(parser.name)
			Rake::Task['vineyard:get_source_location_uri'].reenable
			Rake::Task['vineyard:get_source_location_uri'].invoke(location, parser)
		end
	end

	def get_vine(location, parser)
		puts "Searching for #{parser.name.capitalize} ID for #{location.name}"
		run = parser.name.capitalize.constantize.new
		unless run.get_location_id_status?
			puts "This source has been marked as having issues finding source_location_uris, choose another source"
			return
		end
		source_location_uri = run.get_location_id(location)
	end

	def find_existing_vines(location)
		# Make sure we don't overwrite existing urls, only find uris for locations without a corrresponding source
		existing_vines = []
		location.vines.each do |vine|
			existing_vines << vine.source.name
		end
		existing_vines
	end

	def set_check_date(location)
		location.update_column(:uri_check_date, Date.today)
	end


end	