require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www.opentable.com/san-antonio-texas-restaurant-listings"
doc = Nokogiri::HTML(open(url))

puts url, doc.css('title').text, "------------"
count = 1
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


	