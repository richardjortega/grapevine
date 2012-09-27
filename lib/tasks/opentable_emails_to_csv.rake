require_relative "../jobs/opentable.rb"

namespace :crawl do
	desc "OpenTable - Export CSV of All Locations with Emails"
	task :opentable do
		filename = "#{Rails.root}/lib/jobs/opentable_scrapelist.txt"
		File.open(filename, "r") do |aFile|
			aFile.each_line do |city_listing|
				listing = city_listing.to_s.chomp!
				run = OpenTableParser.new city_listing
				run.parser_engine
			end
		end
	end
end