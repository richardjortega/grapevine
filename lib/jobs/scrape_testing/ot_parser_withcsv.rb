require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'logger'
require 'ap'
require 'debugger'
require 'watir-webdriver'

caps = Selenium::WebDriver::Remote::Capabilities.chrome
#version not needed for chrome
#caps.version = "5.0"
caps.platform = 'Windows 2008'
caps[:name] = "Testing Selenium 2 with Ruby on Sauce"

# for when you want to run locally
browser = Watir::Browser.new :firefox

# for when you want to run on Saucelabs
# browser = Watir::Browser.new(
#   :remote,
#   :url => "http://richardjortega:c9192142-8576-4adf-a427-9b19e6b9b218@ondemand.saucelabs.com:80/wd/hub",
#   :desired_capabilities => caps)

url = "http://www.opentable.com/acenar"
browser.goto url
sleep 1
doc = Nokogiri::HTML(browser.html).css('div.section.main')
browser.close

begin
	found_details = doc.collect do |detail|
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
			review_rating = detail.at_css("#BVReviewsContainer .BVRRRatingNormalImage img.BVImgOrSprite").attr("title")
			parsed_detail[:review_rating] = "#{review_rating.to_f}" + " out of 5"
		end

		# Possiblity of no review descriptions, therefore we shouldn't track this location as it wouldn't have good data anyway.
		parsed_detail[:review_description] = detail.at_css('span.BVRRReviewText').text
		
		parsed_detail[:review_dine_date] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text[/\d+\/\d+\/\d+/]
		stubbed_link = URI.parse("#{url}").path[1..-1]
		parsed_detail[:marketing_url] = "http://www.pickgrapevine.com/wantmore6/#{stubbed_link}"
		parsed_detail[:marketing_id] = stubbed_link
		puts "Finished scrapping"
		parsed_detail
	end			
rescue => e
	pp e.message
	pp e.backtrace
	puts "Encountered error on #{url} page, moving on..."
	# Nil values handled in parser with Array#compact
end

found_details.compact!
found_details.flatten!

@source = "testsource"
@directory_listing = "somecity"

# CSV export

CSV.open("/Users/iMac/Dropbox/Code/grapevine/lib/jobs/scrape_testing/#{@source}_#{@directory_listing}.csv", "wb", encoding: "UTF-8") do |row|
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

ap found_details