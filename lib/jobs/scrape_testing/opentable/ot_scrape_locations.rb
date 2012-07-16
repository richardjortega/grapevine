require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'



url = "http://www.opentable.com/san-antonio-texas-restaurant-listings"
doc = Nokogiri::HTML(open(url)).css('tr.ResultRow')

found_locations = doc.collect do |listing|
	parsed_locations = Hash.new
	parsed_locations[:Name] = listing.css('td.ReCol a.r').text #name
	parsed_locations[:Url] = listing.css('td.ReCol a.r').first[:href] #url
	parsed_locations
end

puts "Finished finding all location pages"
puts "Please provide a output filename"
puts "Note: .csv will be appended for you, also spaces should be underscores"
puts '> '
filename = STDIN.gets.chomp()

CSV.open("#{filename}.csv", "wb") do |row|
	row << [ "name", "url" ]
	found_locations.each do |location|
		row << [ location[:Name], location[:Url] ]
	end
end
puts found_locations


#use as reference, for temrinal only
# puts url, doc.css('title').text, "------------"
# count = 1
# doc.css('tr.ResultRow').each do |listing|
# 	puts "---- #{count}--------"
# 	puts "Restaurant Name: " + listing.css('td.ReCol a.r').text
# 	puts "Link: " + listing.css('td.ReCol a.r').first[:href]
# 	puts "Neighborhood & Cuisine: " + listing.css('td.ReCol div.d').text
# 	puts "Rating: " + listing.css('td.RaCol div.Ratings div.Star').first[:title]
# 	puts "No of Reviews: " + listing.css('td.RaCol div.Ratings').text
# 	puts "Price: " + listing.css('td.PrCol').text
# 	count += 1
# 	puts "---------------------"
# 	puts ''
# end


	