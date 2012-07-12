require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'logger'

logger = Logger.new(STDOUT)

url = "http://www.opentable.com/20nine-restaurant-and-wine-bar"

doc = Nokogiri::HTML(open(url)).css('div.section.main')

found_details = Array.new
		doc.each do |detail|
			parsed_detail = Hash.new
			# General information
			parsed_detail[:name] = detail.css('span#ProfileOverview_RestaurantName.title').text
			parsed_detail[:rating] = detail.css('span.Star').first[:title]
			parsed_detail[:address] = detail.css('span#ProfileOverview_lblAddressText').text
			parsed_detail[:total_reviews] = detail.css('span.reviews a').text
			parsed_detail[:cuisine] = detail.css('span#ProfileOverview_lblCuisineText').text
			parsed_detail[:price] = detail.css('span#ProfileOverview_lblPriceText').text
			parsed_detail[:neighborhood] = detail.css('span#ProfileOverview_lblNeighborhoodText').text
			# The juicy shiznitz
			parsed_detail[:website] = detail.css('ul.detailsList li#ProfileOverview_Website a').text
			parsed_detail[:email] = detail.css('ul.detailsList li#ProfileOverview_Email a').text
			parsed_detail[:phone] = detail.css('ul.detailsList li#ProfileOverview_Phone span.value').text
			# Grab last review
			parsed_detail[:review_rating] = detail.at_css("img.BVImgOrSprite").attr("title")
			parsed_detail[:review_description] = detail.at_css('span.BVRRReviewText').text
			parsed_detail[:review_diner_info] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text
			found_details << parsed_detail
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




	