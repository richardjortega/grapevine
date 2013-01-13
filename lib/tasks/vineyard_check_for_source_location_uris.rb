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
				Rake::Task['get_source_location_uri:yelp'].reenable
				Rake::Task['get_source_location_uri:yelp'].invoke(location_id, term, lat, long)
			end

			unless existing_vines.include?('google')
				Rake::Task['get_source_location_uri:google'].reenable
				Rake::Task['get_source_location_uri:google'].invoke(location_id, term, lat, long)
			end

			unless existing_vines.include?('urbanspoon')
				Rake::Task['get_source_location_uri:urbanspoon'].reenable
				Rake::Task['get_source_location_uri:urbanspoon'].invoke(location_id, term, street_address, city, state, zip)
			end

			unless existing_vines.include?('tripadvisor')
				Rake::Task['get_source_location_uri:tripadvisor'].reenable
				Rake::Task['get_source_location_uri:tripadvisor'].invoke(location_id, term, street_address, city, state, zip)
			end

			unless existing_vines.include?('google')
				Rake::Task['get_source_location_uri:opentable'].reenable
				Rake::Task['get_source_location_uri:opentable'].invoke(location_id, term, street_address, city, state, zip)
			end


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
		Vine.new(:source_id 			=> source_id, 
				 :location_id 			=> location_id, 
				 :source_location_uri   => source_location_uri)
		vine.save!
		puts "Added Yelp source_location_uri '#{source_location_uri}' to #{term}"	

	end

	desc 'Find Google ID# : term, lat, long (Assumes 1st is right)'
	task :google, [:location_id, :term, :lat, :long] => :environment do |t, args|
		source = Source.find_by_name('google')
		source_id = source.id
		location_id = args[:location_id]
		term = args[:term]
		lat = args[:lat]
		long = args[:long]
		puts "Searching for Google ID using term: #{term}"
		run = Google.new
		source_location_uri = run.get_location_id(term, lat, long)
		Vine.new(:source_id 			=> source_id, 
				 :location_id 			=> location_id, 
				 :source_location_uri   => source_location_uri)
		vine.save!
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
		Vine.new(:source_id 			=> source_id, 
				 :location_id 			=> location_id, 
				 :source_location_uri   => source_location_uri)
		vine.save!
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
		Vine.new(:source_id 			=> source_id, 
				 :location_id 			=> location_id, 
				 :source_location_uri   => source_location_uri)
		vine.save!
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
		Vine.new(:source_id 			=> source_id, 
				 :location_id 			=> location_id, 
				 :source_location_uri   => source_location_uri)
		vine.save!
		puts "Added OpenTable source_location_uri '#{source_location_uri}' to #{term}"	
	end
end