require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'logger'
require 'ap'
require 'debugger'
require 'watir-webdriver'

def check_for_new_reviews(new_reviews, current_reviews) 
	# checks new reviews against old reviews in array and only returns new ones.
	latest_review_date = Date.strptime(current_reviews.first[:review_dine_date], "%m/%d/%Y")

	new_reviews.each do |review|
		# compare each review  and check if their dates are newer than latest in DB/array
		parsed_review_date = Date.strptime(review[:review_dine_date], "%m/%d/%Y")
		if parsed_review_date > latest_review_date
			current_reviews << review
		end
	end
	# Use order for AR when referencing DB
	# latest_review_date = Location.Reviews.order("review_dine_date DESC").first.review_dine_date
end

caps = Selenium::WebDriver::Remote::Capabilities.chrome
#version not needed for chrome
#caps.version = "5.0"
caps.platform = 'Windows 2008'
caps[:name] = "Testing Selenium 2 with Ruby on Sauce"

# for when you want to run locally
browser = Watir::Browser.new :firefox

# for when you want to run on Saucelabs
# browser = Watir::Browser.new(
#   :remote,
#   :url => "http://richardjortega:c9192142-8576-4adf-a427-9b19e6b9b218@ondemand.saucelabs.com:80/wd/hub",
#   :desired_capabilities => caps)

# New reviews are only checked on review date, not on uniqueness of text
# Set new reviews (one old review with old date, add - ensure not duplicated, two new reviews with newer dates, one review our of order)
new_reviews = [{ :review_rating => "2.0 out of 5",
        		 :review_description => "I had a group of 6 and everyone's meat was under seasoned. The lobster bisque was very bland. The waitress was rude at times. I will not return to Morton's.",
          		 :review_dine_date => "11/10/2012"},
          	   { :review_rating => "1.0 out of 5",
        		 :review_description => "Food was so-so for Xmas brunch, would not recommend.",
          		 :review_dine_date => "12/26/2012" },
          	   { :review_rating => "3.0 out of 5",
        		 :review_description => "fuck this place!!!",
          		 :review_dine_date => "5/26/2013" },
    		   { :review_rating => "5.0 out of 5",
        		 :review_description => "Great place to start the New Year with, great bartenders too!",
          		 :review_dine_date => "1/15/2013" }]



# url has really weird characters
url = "http://www.opentable.com/mortons-the-steakhouse-troy?scpref=110&tab=2"
# url has a degree (special character in restaurant name)
#url = "http://www.opentable.com/42-degrees-north?scpref=110"
browser.goto url
sleep 1
doc = Nokogiri::HTML(browser.html).css('div.BVRRDisplayContentBody')
browser.close

found_details = []

begin
	doc.css('[id*="BVRRDisplayContentReviewID"]').each do |detail|
		parsed_detail = {}

		# Set review rating default in case it returns nil
		if detail.at_css("img.BVImgOrSprite").nil?
			parsed_detail[:review_rating] = ""
		else
			review_rating = detail.at_css("img.BVImgOrSprite").attr("title")
			parsed_detail[:review_rating] = "#{review_rating.to_f}" + " out of 5"
		end

		# Possiblity of no review descriptions, therefore we shouldn't track this location as it wouldn't have good data anyway.
		parsed_detail[:review_description] = detail.at_css('span.BVRRReviewText').text
		
		parsed_detail[:review_dine_date] = detail.at_css('div.BVRRAdditionalFieldValueContainer.BVRRAdditionalFieldValueContainerdinedate').text[/\d+\/\d+\/\d+/]
		found_details << parsed_detail
	end			
rescue => e
	pp e.message
	pp e.backtrace
	puts "Encountered error on #{url} page, moving on..."
	# Nil values handled in parser with Array#compact
end

details = found_details.compact.flatten
ap details

check_for_new_reviews(new_reviews, details)
ap details





