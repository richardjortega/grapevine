# require all apis and scrappers to search against.
# Dir["../vineyard/*.rb"].each {|file| require file }
require_relative '../vineyard/opentable.rb'
require_relative '../vineyard/yelp.rb'
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
			location_id = '28474'
			latest_review = {:post_date => '11/29/2012', :comment => 'asdfad'}

			run = OpenTable.new location_id
			response = run.get_new_reviews latest_review
			puts response
		#end
	end


	desc "Check OpenTable for new reviews"
	task :yelp => :environment do
		# Location.all.each do |location|
			# location_id = location.source('opentable').matchingid

			# for testing
			latest_review = {:post_date => '01/29/2012', :comment => 'asdfad'}
			location_id = 'rosarios-mexican-cafe-y-cantina-san-antonio'

			run = Yelp.new location_id
			response = run.get_new_reviews latest_review
			puts response
		# end
	end

end