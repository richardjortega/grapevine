require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

class OpenTableParser

	def initialize()
		@city_location_link = "http://www.opentable.com/san-antonio-texas-restaurant-listings"

	end

	def parser_engine
		logger = Logger.new(STDOUT)

		puts "Parsing locations..."
		links = parse_locations
		puts "Finished finding all locations' pages"

		puts "Scraping Each Location for Data.."
		found_details = links.collect do |location_link| 
			parse_location_page(location_link)
		end
		puts "Finished Obtaining Data."
		
		puts ''
		puts "Output Ready. Please provide a output filename"
		puts "Note: .csv will be appended for you, also spaces should be underscores"
		puts '> '
		filename = STDIN.gets.chomp()

		CSV.open("#{filename}.csv", "wb") do |row|
			row << [ "name", "rating", "address", "total reviews", "cuisine", "price", "neighborhood", "website", "email", "phone", "review rating", "review description", "review diner info" ]
			found_details.each do |location|
				row << [ location[:name], location[:rating], location[:address], 
				location[:total_reviews], location[:cuisine], location[:price], 
				location[:neighborhood], location[:website], location[:email], location[:phone], 
				location[:review_rating], location[:review_description], location[:review_diner_info] ]
			end
		end
		puts "File outputted as '#{filename}.csv'"
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
			parsed_details[:name] = detail.css('span#ProfileOverview_RestaurantName.title').text
			parsed_details[:rating] = detail.css('span.Star').first[:title]
			parsed_details[:address] = detail.css('span#ProfileOverview_lblAddressText').text
			parsed_details[:total_reviews] = detail.css('span.reviews a').text
			parsed_details[:cuisine] = detail.css('span#ProfileOverview_lblCuisineText').text
			parsed_details[:price] = detail.css('span#ProfileOverview_lblPriceText').text
			parsed_details[:neighborhood] = detail.css('span#ProfileOverview_lblNeighborhoodText').text
			# The juicy shiznitz
			parsed_details[:website] = detail.css('ul.detailsList li#ProfileOverview_Website a').text
			parsed_details[:email] = detail.css('ul.detailsList li#ProfileOverview_Email a').text
			parsed_details[:phone] = detail.css('ul.detailsList li#ProfileOverview_Phone span.value').text
			# Grab last review
			parsed_details[:review_rating] = detail.at_css("img.BVImgOrSprite").attr("title")
			parsed_details[:review_description] = detail.at_css('span.BVRRReviewText').text
			parsed_details[:review_diner_info] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text
			parsed_details
		end		
	end

end
