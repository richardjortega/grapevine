require 'rubygems'
require 'nokogiri'
require 'open-uri'

#get some damn emails from opentable
class OpenTableParser

	def initialize()
		@city_location_link = "http://www.opentable.com/san-antonio-texas-restaurant-listings"
	end

	def parse_all_
	end

	def search_for_emails(location_link)

		url = "http://www.opentable.com/#{location_link}"
		doc = Nokogiri::HTML(open(url))

		puts url, doc.css('title').text, "------------"
		count = 1
	end

	def parse_locations_page
		found_locations = Array.new
		locations = Nokogiri::HTML(open("@city_location_link")).css("tr.ResultRow")
		locations.each do |location|
			url = location.css('td.ReCol a.r').first[:href]
			my_html = read_html "http://www.opentable.com/#{url}"
			doc = Nokogiri::HTML(my_html)
			

			

		doc.css('tr.ResultRow').each do |listing|
			puts "---- #{count}--------"
			puts "Restaurant Name: " + listing.css('td.ReCol a.r').text
			puts "Link: " + listing.css('td.ReCol a.r').first[:href]
			puts "Neighborhood & Cuisine: " + listing.css('td.ReCol div.d').text
			puts "Rating: " + listing.css('td.RaCol div.Ratings div.Star').first[:title]
			puts "No of Reviews: " + listing.css('td.RaCol div.Ratings').text
			puts "Price: " + listing.css('td.PrCol').text
			count += 1
			puts "---------------------"
			puts ''
		end
	end

end
