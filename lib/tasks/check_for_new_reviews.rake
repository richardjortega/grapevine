# require all apis and scrappers to search against.
# Dir["../vineyard/*.rb"].each {|file| require file }
require_relative '../vineyard/opentable.rb'
require_relative "../../app/models/review"
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
		
		# array of restaurant ids passed with corresponding latest review date
		# loop through each one

		location_id = '28474'
		latest_review = {:post_date => '11/29/2012', :comment => 'asdfad'}

		run = OpenTable.new
		response = run.get_new_reviews(location_id, latest_review)
		puts response
	end

end