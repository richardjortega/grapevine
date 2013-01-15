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

			unless existing_vines.include?('googleplus')
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

			puts "Finished checking #{location.name} for possible missing source_location_uris."
		end
		puts "Finished checking all locations for any source_location_uris that may have been missing. Thank you, pwnage."
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
			add_new_vine(source, location_id, source_location_uri, term)
		end
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
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end

	desc 'Find UrbanSpoon ID# : term, street_address, city, state, zip (Assumes 1st is right)'
	task :urbanspoon, [:location_id, :term, :street_address, :city, :state, :zip] => :environment do |t, args|
		source = Source.find_by_name('urbanspoon')
		source_id = source.id
		args.with_defaults(:street_address => "", :city => "", :state => "", :zip => "")
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
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end

	desc 'Find TripAdvisor ID# : term, street_address, city, state, zip (Assumes 1st is right)'
	task :tripadvisor, [:location_id, :term, :street_address, :city, :state, :zip] => :environment do |t, args|
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
		run = TripAdvisor.new
		source_location_uri = run.get_location_id(term, street_address, city, state, zip)
		unless source_location_uri ==  "Could not find any matching information"
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end

	desc 'Find OpenTable ID# : term, street_address, city, state, zip (Assumes 1st is right)'
	task :opentable, [:location_id, :term, :street_address, :city, :state, :zip] => :environment do |t, args|
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
		run = OpenTable.new
		source_location_uri = run.get_location_id(term, street_address, city, state, zip)
		next if source_location_uri.nil?
		unless source_location_uri ==  "Could not find any matching information"
			add_new_vine(source, location_id, source_location_uri, term)
		end
	end
end


private

	def add_new_vine(source, location_id, source_location_uri, term)
		new_vine = Vine.new(:source_id 			   => source.id, 
				 			:location_id 		   => location_id, 
							:source_location_uri   => source_location_uri)
		new_vine.save!
		puts "Added #{source.name} source_location_uri '#{source_location_uri}' to #{term}"	
	end
