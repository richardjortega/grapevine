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

browser = Watir::Browser.new(
  :remote,
  :url => "http://richardjortega:c9192142-8576-4adf-a427-9b19e6b9b218@ondemand.saucelabs.com:80/wd/hub",
  :desired_capabilities => caps)

url = "http://www.opentable.com/artisan-hotel-boutiques-mood-restaurant?scpref=110&tab=2"
browser.goto url
sleep 1
doc = Nokogiri::HTML(browser.html).css('div.section.main')
browser.close

begin
	found_details = doc.collect do |detail|
		parsed_detail = {}

		#Declutter address
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
	
		parsed_detail[:address_line_1] = address_parts[0]
		parsed_detail[:address_line_2] = address_parts[1]
		parsed_detail[:address_line_3] = address_parts[2]
		parsed_detail[:total_reviews] = detail.css('span.reviews a').text[/\d+/]
		parsed_detail[:cuisine] = detail.css('span#ProfileOverview_lblCuisineText').text
		parsed_detail[:price] = detail.css('span#ProfileOverview_lblPriceText').text
		parsed_detail[:neighborhood] = detail.css('span#ProfileOverview_lblNeighborhoodText').text
		parsed_detail[:website] = detail.css('ul.detailsList li#ProfileOverview_Website a').text
		parsed_detail[:email] = detail.css('ul.detailsList li#ProfileOverview_Email a').text
		parsed_detail[:phone] = detail.css('ul.detailsList li#ProfileOverview_Phone span.value').text
		# Grabs last review

		# Set review rating default in case it returns nil
		if detail.at_css("img.BVImgOrSprite").nil?
			parsed_detail[:review_rating] = ""
		else
			parsed_detail[:review_rating] = detail.at_css("img.BVImgOrSprite").attr("title")
		end
		

		parsed_detail[:review_description] = detail.at_css('span.BVRRReviewText').text


		parsed_detail[:review_dine_date] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text[/\d+\/\d+\/\d+/]
		puts "Finished scrapping: " + parsed_detail[:name]
		puts parsed_detail
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
ap found_details