require_relative "../jobs/opentable.rb"
require_relative "../jobs/open_file.rb"

namespace :opentable do
	desc "OpenTable - Export CSV of All Locations with Emails"
	task :get_emails do
		filename = "#{Rails.root}/lib/jobs/opentable_scrapelist.txt"
		File.open(filename, "r") do |aFile|
			debugger
			aFile.each_line do |city_listing|
				listing = city_listing.to_s.chomp!
				run = OpenTableParser.new city_listing
				run.parser_engine
			end
		end
	end
end