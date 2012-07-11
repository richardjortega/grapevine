require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

class OpenTableParser

	def initialize()
		@city_location_link = "http://www.opentable.com/san-antonio-texas-restaurant-listings"

	end

	def parser_engine
		puts "Parsing locations..."
		links = parse_locations

		puts "Found Locations. Scraping Each Location Link for Data.."
		found_details = links.collect do |location_link| 
			parse_location_page(location_link)
		end

		puts "Preparing CSV file"
		CSV.open('opentable_san_antonio.csv', 'wb') do |row|
			row << [ "name", "rating", "address", "total reviews", "cuisine", "price", "neighborhood", "website", "email", "phone", "review rating", "review description", "review diner info" ]
			found_details.each do |detail|
				row << [ detail ]
			end
		end
		puts "File outputted as 'opentable_san_antonio.csv'"
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
		url = "http://www.opentable.com/#{link}"
		doc = Nokogiri::HTML(open(url)).css('div.section.main')

		found_details = doc.collect do |detail|
			parsed_details = Hash.new
			# General information
			parsed_details[:Name] = detail.css('span#ProfileOverview_RestaurantName.title').text
			parsed_details[:Rating] = detail.css('span.Star').first[:title]
			parsed_details[:Address] = detail.css('span#ProfileOverview_lblAddressText').text
			parsed_details[:Total_Reviews] = detail.css('span.reviews a').text
			parsed_details[:Cuisine] = detail.css('span#ProfileOverview_lblCuisineText').text
			parsed_details[:Price] = detail.css('span#ProfileOverview_lblPriceText').text
			parsed_details[:Neighborhood] = detail.css('span#ProfileOverview_lblNeighborhoodText').text
			# The juicy shiznitz
			parsed_details[:Website] = detail.css('ul.detailsList li#ProfileOverview_Website a').text
			parsed_details[:Email] = detail.css('ul.detailsList li#ProfileOverview_Email a').text
			parsed_details[:Phone] = detail.css('ul.detailsList li#ProfileOverview_Phone span.value').text
			# Grab last review
			parsed_details[:Review_Rating] = detail.at_css("img.BVImgOrSprite").attr("title")
			parsed_details[:Review_Description] = detail.at_css('span.BVRRReviewText').text
			parsed_details[:Review_Diner_Info] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text
			parsed_details
		end		
	end

end
