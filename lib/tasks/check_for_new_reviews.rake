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
	task :opentable, [:location_id] => :environment do |t, location_id|
		
		run = OpenTable.new
		response = run.parse_review_page(location_id)

	end

end