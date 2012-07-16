require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pp'

class OpenTableParser

	def initialize()
		@source = "opentable.com"
		@directory_listing = "san-antonio-texas-restaurant-listings"
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

		### For quick testing, only uses two links
		# twolinks = Array.new
		# twolinks << links[0] << links[1]
		# found_details = twolinks.collect do |location_link|
		# 	parse_location_page(location_link)
		# end

		# Probably should be broken to another method
		# Parse all pages on the returned pages
		found_details = links.collect do |location_link|
			parse_location_page(location_link)
		end
		
		# Remove any nil values from the returned array
		found_details.compact!

		# Flatten array or array of hashes to one-dimensional array of hashes
	    found_details.flatten!

		puts "Finished Scrapping All Locations' Data."
		puts "Total Time to Scrape All Data: #{((Time.now - job_start_time)/60).to_i} minutes"

		# Uses CSV from Ruby Core lib, this data has no owner so won't interact with our DB.
		CSV.open("#{Rails.root}/lib/exported_lists/#{@source}_#{@directory_listing}.csv", "wb") do |row|
			row << [ "name", "rating", "address", "total reviews", "cuisine", "price", "neighborhood", "website", "email", "phone", "review rating", "review description", "review dine date" ]
			
			found_details.each do |location|
				row << [ location[:name], 
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
					location[:review_dine_date] ]
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

	def parse_location_page(link)
		begin
			url = "http://www.opentable.com/#{link}"
			puts "Scrapping: " + url
			job_start_time = Time.now
			doc = Nokogiri::HTML(open(url)).css('div.section.main')

			doc.collect do |detail|
				parsed_detail = Hash.new
					
				# Declutter address
				address = detail.css('span#ProfileOverview_lblAddressText').first.inner_html
				address_parts = address.split("<br>")

				# General information
				parsed_detail[:name] = detail.css('span#ProfileOverview_RestaurantName.title').text
				parsed_detail[:rating] = detail.css('span.Star').attr("title")
				
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
				
				# Grabs last review
				parsed_detail[:review_rating] = detail.at_css("img.BVImgOrSprite").attr("title")
				parsed_detail[:review_description] = detail.at_css('span.BVRRReviewText').text
				parsed_detail[:review_dine_date] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text[/\d+\/\d+\/\d+/]
				puts "Finished scrapping: " + parsed_detail[:name] + "in #{(Time.now - job_start_time)} seconds"
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
