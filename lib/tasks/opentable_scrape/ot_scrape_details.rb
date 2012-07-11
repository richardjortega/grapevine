require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

url = "http://www.opentable.com/20nine-restaurant-and-wine-bar"
doc = Nokogiri::HTML(open(url))


details = Array.new
review = Array.new

doc.css('div.section.main').each do |details|
	# General information
	puts "Restaurant Name: " + details.css('span#ProfileOverview_RestaurantName.title').text
	puts "Rating: " + details.css('span.Star').first[:title]
	puts "Address: " + details.css('span#ProfileOverview_lblAddressText').text
	puts "Total Reviews: " + details.css('span.reviews a').text
	puts "Cuisine: " + details.css('span#ProfileOverview_lblCuisineText').text
	puts "Price: " + details.css('span#ProfileOverview_lblPriceText').text
	puts "Neighborhood: " + details.css('span#ProfileOverview_lblNeighborhoodText').text
	# The juicy shiznitz
	puts "Website: " + details.css('ul.detailsList li#ProfileOverview_Website a').text
	puts "Email: " + details.css('ul.detailsList li#ProfileOverview_Email a').text
	puts "Phone: " + details.css('ul.detailsList li#ProfileOverview_Phone span.value').text
	# Review for sending
	puts "Review Rating: " + details.at_css("img.BVImgOrSprite").attr("title")
	puts "Review Description: " + details.at_css('span.BVRRReviewText').text
	puts "Review Diner Info: " + details.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text

end

#CSV.open('opentable_scrape.csv')




	