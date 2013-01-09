require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'iconv'
require 'pp'
require 'watir-webdriver'

class OpenTableChecker

	def initialize(city_listing)
		@source = "opentable.com"
		@directory_listing = city_listing
		@city_location_link = "http://www.#{@source}/#{@directory_listing}"
	end

	# I know the parser engine should be broken out but this is just a spike example
	def parser_engine

		job_start_time = Time.now

		puts "Parsing locations..."
		links = parse_locations

		puts "Finished finding all locations' pages"
		puts "Total Time: #{Time.now - job_start_time} seconds"

		puts "Scraping Data from Each Location..."

		# Spin up a cloud browser to execute JS with (Mac desktop with Chrome)
		# browser = get_saucy

		# Spin up browser locally
		browser = run_browser_locally

		# Parse all pages on the returned pages
		found_details = links.collect do |location_link|
			parse_location_page(location_link, browser)
		end

		# Close browser session on saucelabs
		browser.close

		# Remove any nil values from the returned array then flatten array of hashes to one-dimensional array of hashes
		details = found_details.compact.flatten

		puts "Finished Scrapping All Locations' Data."
		puts "Total Time to Scrape All Data: #{((Time.now - job_start_time)/60).to_i} minutes"

		# Uses CSV from Ruby Core lib, this data has no owner so won't interact with our DB.
		CSV.open("#{Rails.root}/lib/exported_lists/#{@source}_#{@directory_listing}.csv", "wb") do |row|
			#Headers for reference, uncomment if you need headers. Each website doesn't need them.
			row << [ "Location Name", "City", "Review Count", "Total Reviews", "Rating", "OT URL", "Phone", "Email" ]
			
			details.each do |location|
				next if location[:total_reviews] < 11
				row << [ location[:location_name], 
						 location[:location_city], 
						 location[:review_count],
						 location[:total_reviews],
						 location[:rating],
						 location[:url],
						 location[:phone],
						 location[:email] ]
			end
		end
		puts "File outputted as 'ot_#{@directory_listing}_last30daysreviewcount.csv'"
		exported_csv = "#{Rails.root}/lib/stats/ot_#{@directory_listing}_last30daysreviewcount.csv"
		exported_csv
	end

	def parse_locations
		doc = Nokogiri::HTML(open(@city_location_link)).css('tr.ResultRow')
		doc.collect do |listing|
			parse_listing(listing)
		end
	end

	def parse_listing(listing)
		listing.css('td.ReCol a.r').first[:href]
	end

	def run_browser_locally
		Watir::Browser.new :firefox
	end

	def get_saucy
		caps = Selenium::WebDriver::Remote::Capabilities.chrome
		#version not needed for chrome
		#caps.version = "5.0"
		caps.platform = 'Windows 2008'
		caps[:name] = "Saucing: #{@directory_listing}"

		browser = Watir::Browser.new(
		  :remote,
		  :url => "http://richardjortega:c9192142-8576-4adf-a427-9b19e6b9b218@ondemand.saucelabs.com:80/wd/hub",
		  :desired_capabilities => caps)
	end

	def parse_location_page(link, browser)
		begin
			url = "http://www.#{@source}/#{link}"
			puts "Scrapping: " + url
			job_start_time = Time.now
			
			browser.goto url
			sleep 0.5
			doc = Nokogiri::HTML(browser.html).css('div.section.main')

			thirty_days_ago = Date.today - 30
			
			#first_review_date = Date.parse('September 11, 2012')
			#total_months = ((Date.today - first_review_date).to_i / 30)

			parsed_details = {}

			parsed_details[:location_name] = doc.css('span#ProfileOverview_RestaurantName.title').text.encode('ISO-8859-1')
			parsed_details[:location_city] = @directory_listing.gsub('-restaurant-listings','')
			parsed_details[:review_count] = 0
			parsed_details[:total_reviews] = doc.css('span.reviews a').text[/\d+/].to_i
			if doc.css('span.Star').nil?
				parsed_details[:rating] = ""
			else
				parsed_details[:rating] = doc.css('span.Star').attr("title").text.to_f
			end
			#parsed_details[:average_monthly_reviews] = (parsed_details[:total_reviews] / total_months.to_f)
			parsed_details[:url] = url
			parsed_details[:phone] = doc.css('ul.detailsList li#ProfileOverview_Phone span.value').text
			parsed_details[:email] = doc.css('ul.detailsList li#ProfileOverview_Email a').text

			doc.css('div.BVRRContentReview').each do |review|
				review_dine_date = review.at_css('span.BVRRValue.BVRRAdditionalField.BVRRAdditionalFielddinedate').text
				review_date = Date.strptime(review_dine_date, '%m/%d/%Y')
				if review_date >= thirty_days_ago
					parsed_details[:review_count] += 1
				end
			end

			puts "Found #{parsed_details[:review_count]} reviews in past 30 days"

			parsed_details

		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{link} page, moving on..."
			# Nil values handled in parser with Array#compact
		end		
	end

end
