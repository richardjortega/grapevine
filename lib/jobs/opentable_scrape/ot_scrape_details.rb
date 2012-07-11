require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

url = "http://www.opentable.com/20nine-restaurant-and-wine-bar"
doc = Nokogiri::HTML(open(url)).css('div.section.main')


found_details = Array.new

doc.each do |details|
	parsed_details = Hash.new
	# General information
	parsed_details["Name"] = details.css('span#ProfileOverview_RestaurantName.title').text
	parsed_details["Rating"] = details.css('span.Star').first[:title]
	parsed_details["Address"] = details.css('span#ProfileOverview_lblAddressText').text
	parsed_details["Total Reviews"] = details.css('span.reviews a').text
	parsed_details["Cuisine"] = details.css('span#ProfileOverview_lblCuisineText').text
	parsed_details["Price"] = details.css('span#ProfileOverview_lblPriceText').text
	parsed_details["Neighborhood"] = details.css('span#ProfileOverview_lblNeighborhoodText').text
	# The juicy shiznitz
	parsed_details["Website"] = details.css('ul.detailsList li#ProfileOverview_Website a').text
	parsed_details["Email"] = details.css('ul.detailsList li#ProfileOverview_Email a').text
	parsed_details["Phone"] = details.css('ul.detailsList li#ProfileOverview_Phone span.value').text
	# Review for sending
	parsed_details["Review Rating"] = details.at_css("img.BVImgOrSprite").attr("title")
	parsed_details["Review Description"] = details.at_css('span.BVRRReviewText').text
	parsed_details["Review Diner Info"] = details.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text
	found_details << parsed_details
end
puts found_details
# as references
# old static for terminal
# doc.css('div.section.main').each do |details|
# 	# General information
# 	puts "Restaurant Name: " + details.css('span#ProfileOverview_RestaurantName.title').text
# 	puts "Rating: " + details.css('span.Star').first[:title]
# 	puts "Address: " + details.css('span#ProfileOverview_lblAddressText').text
# 	puts "Total Reviews: " + details.css('span.reviews a').text
# 	puts "Cuisine: " + details.css('span#ProfileOverview_lblCuisineText').text
# 	puts "Price: " + details.css('span#ProfileOverview_lblPriceText').text
# 	puts "Neighborhood: " + details.css('span#ProfileOverview_lblNeighborhoodText').text
# 	# The juicy shiznitz
# 	puts "Website: " + details.css('ul.detailsList li#ProfileOverview_Website a').text
# 	puts "Email: " + details.css('ul.detailsList li#ProfileOverview_Email a').text
# 	puts "Phone: " + details.css('ul.detailsList li#ProfileOverview_Phone span.value').text
# 	# Review for sending
# 	puts "Review Rating: " + details.at_css("img.BVImgOrSprite").attr("title")
# 	puts "Review Description: " + details.at_css('span.BVRRReviewText').text
# 	puts "Review Diner Info: " + details.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text

# end

#CSV.open('opentable_scrape.csv')




	