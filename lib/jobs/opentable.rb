require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pp'
require 'watir-webdriver'

class OpenTableParser

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
		found_details.compact!.flatten!

		puts "Finished Scrapping All Locations' Data."
		puts "Total Time to Scrape All Data: #{((Time.now - job_start_time)/60).to_i} minutes"

		# Uses CSV from Ruby Core lib, this data has no owner so won't interact with our DB.
		CSV.open("#{Rails.root}/lib/exported_lists/#{@source}_#{@directory_listing}.csv", "wb") do |row|
			#Headers for reference, uncomment if you need headers. Each website doesn't need them.
			#row << [ "name", "url", "rating", "address", "total_reviews", "cuisine", "price", "neighborhood", "website", "email", "phone", "review_rating", "review_description", "review_dine_date", "marketing_url", "marketing_id" ]
			
			found_details.each do |location|
				next if location[:email].empty? #skip adding rows if no email is present
				row << [ location[:name],
					location[:url], 
					location[:rating], 
					location[:address],
					location[:total_reviews], 
					location[:cuisine], 
					location[:price], 
					location[:neighborhood], 
					location[:website], 
					location[:email], 
					location[:phone], 
					location[:review_rating], 
					location[:review_description], 
					location[:review_dine_date],
					location[:marketing_url],
					location[:marketing_id] ]
			end
		end
		puts "File outputted as '#{@source}_#{@directory_listing}.csv'"
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

			doc.collect do |detail|
				parsed_detail = {}
					
				parsed_detail[:url] = "#{url}&tab=2"

				# Declutter address
				address = detail.css('span#ProfileOverview_lblAddressText').first.inner_html
				address_parts = address.split("<br>")

				# General information
				parsed_detail[:name] = detail.css('span#ProfileOverview_RestaurantName.title').text

				# Set overall rating default in case it returns nil
				if detail.css('span.Star').nil?
					parsed_detail[:rating] = ""
				else
					parsed_detail[:rating] = detail.css('span.Star').attr("title").text
				end

				# This string interpolation allows for single line address where breaks are converted to spaces
				parsed_detail[:address] = "#{address_parts[0]} #{address_parts[1]} #{address_parts[2]}"

				# Learned some regex! Kinda useful
				parsed_detail[:total_reviews] = detail.css('span.reviews a').text[/\d+/]
				
				parsed_detail[:cuisine] = detail.css('span#ProfileOverview_lblCuisineText').text
				parsed_detail[:price] = detail.css('span#ProfileOverview_lblPriceText').text
				parsed_detail[:neighborhood] = detail.css('span#ProfileOverview_lblNeighborhoodText').text
				parsed_detail[:website] = detail.css('ul.detailsList li#ProfileOverview_Website a').text
				parsed_detail[:email] = detail.css('ul.detailsList li#ProfileOverview_Email a').text
				parsed_detail[:phone] = detail.css('ul.detailsList li#ProfileOverview_Phone span.value').text

				# Set review rating default in case it returns nil
				if detail.at_css("img.BVImgOrSprite").nil?
					parsed_detail[:review_rating] = ""
				else
					parsed_detail[:review_rating] = detail.at_css("#BVReviewsContainer .BVRRRatingNormalImage img.BVImgOrSprite").attr("title")
				end

				# Possiblity of no review descriptions, therefore we shouldn't track this location as it wouldn't have good data anyway.
				parsed_detail[:review_description] = detail.at_css('span.BVRRReviewText').text
				
				parsed_detail[:review_dine_date] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text[/\d+\/\d+\/\d+/]
				stubbed_link = URI.parse("#{url}").path[1..-1]
				parsed_detail[:marketing_url] = "http://www.pickgrapevine.com/wantmore5/#{stubbed_link}"
				parsed_detail[:marketing_id] = stubbed_link
				puts "Finished scrapping: " + parsed_detail[:name] + " in #{(Time.now - job_start_time)} seconds"
				parsed_detail
			end
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{link} page, moving on..."
			# Nil values handled in parser with Array#compact
		end		
	end

end
