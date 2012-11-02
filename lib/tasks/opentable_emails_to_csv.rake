require_relative "../jobs/opentable.rb"

namespace :crawl do
	desc "OpenTable - Export CSV of All Locations with Emails"
	task :opentable do
		# File to be updated for scrapping
		filename = "#{Rails.root}/lib/jobs/opentable_scrapelist.txt"
		
		# Output name for final csv file, compilation of all scraped files.
		outputted_csv_name = File.open(filename, 'r') do |f|
			lines = f.readlines.map(&:chomp)
			names = lines.join('_').gsub(/-restaurant-listings/,'')
		end

		# Array for csv filename locations from parser output
		input_files = []

		# Actual parser command, exports a csv for the city and returns a csv filename
		File.open(filename, "r") do |aFile|
			aFile.each_line do |city_listing|
				listing = city_listing.to_s.chomp!
				run = OpenTableParser.new city_listing
				result = run.parser_engine
				input_files << result
			end
		end

		# Array for rows from all csvs
		all_rows = []

		# Iterate through each row in all csvs outputted.
		input_files.each do |input_file|
			# Add UTF-8 encoding so csv's can live happy
			csv = CSV.table(input_file, :headers => false, encoding: "ISO8859-1")
			in_rows = csv.to_a
			all_rows.concat(in_rows)
		end

		# Store the file into a familiar name for exporting to mailchimp
		CSV.open("#{Rails.root}/lib/marketinglist/filtered_lists/ot_#{outputted_csv_name}.csv", 'w', encoding: "ISO8859-1") do |csv|
			all_rows.each {|row| csv << row}
		end

		puts "Outputted all scraped listings to: grapevine/lib/marketinglist/filtered_lists/ot_#{outputted_csv_name}.csv"
	end
end