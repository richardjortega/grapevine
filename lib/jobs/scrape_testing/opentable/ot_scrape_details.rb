require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'logger'
require 'pp'
require 'debugger'


url = "http://www.opentable.com/bohanans-prime-steaks-and-seafood?scpref=109"

doc = Nokogiri::HTML(open(url)).css('div.section.main')

begin
	found_details = doc.collect do |detail|
		parsed_detail = Hash.new

		#Declutter address
		address = detail.css('span#ProfileOverview_lblAddressText').first.inner_html
		address_parts = address.split("<br>")

		# General information
		parsed_detail[:name] = detail.css('span#ProfileOverview_RestaurantName.title').text
		parsed_detail[:rating] = detail.css('span.Star').attr("title")
	
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
		parsed_detail[:review_rating] = detail.at_css("img.BVImgOrSprite").attr("title")
		parsed_detail[:review_description] = detail.at_css('span.BVRRReviewText').text
		parsed_detail[:review_dine_date] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text[/\d+\/\d+\/\d+/]
		puts "Finished scrapping: " + parsed_detail[:name]
		parsed_detail
	end			
rescue => e
	pp e.message
	pp e.backtrace
	puts "Encountered error on #{link} page, moving on..."
	# Nil values handled in parser with Array#compact
end

debugger
#found_details.flatten!
found_details.compact!

# puts "Output Ready. Please provide a output filename"
# puts "Note: .csv will be appended for you, also spaces should be underscores"
# print '> '
# filename = STDIN.gets.chomp()

CSV.open("test.csv", "wb") do |row|
	row << [ "name", "rating", "address line 1", "address line 2", "address line 3", "total reviews", "cuisine", "price", "neighborhood", "website", "email", "phone", "review rating", "review description", "review dine date" ]
	found_details.each do |location|
			row << [ location[:name], 
				location[:rating], 
				location[:address_line_1], 
				location[:address_line_2], 
				location[:address_line_3],
				location[:total_reviews], 
				location[:cuisine], 
				location[:price], 
				location[:neighborhood], 
				location[:website], 
				location[:email], 
				location[:phone], 
				location[:review_rating], 
				location[:review_description], 
				location[:review_dine_date] ]
	end
end




	