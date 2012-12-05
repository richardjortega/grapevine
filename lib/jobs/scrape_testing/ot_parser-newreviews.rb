require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'logger'
require 'ap'
require 'debugger'
require 'watir-webdriver'

def check_for_new_reviews(new_reviews, current_reviews) 
	# checks new reviews against old reviews in array and only returns new ones.
	# Use order for AR when referencing DB
	# latest_review_date = Location.Reviews.order("review_dine_date DESC").first.review_dine_date
	latest_review_date = Date.strptime(current_reviews.first[:review_dine_date], "%m/%d/%Y")

	new_reviews_to_add = []
	new_reviews.each do |review|
		# compare each review  and check if their dates are newer than latest in DB/array
		parsed_review_date = Date.strptime(review[:review_dine_date], "%m/%d/%Y")
		if parsed_review_date >= latest_review_date
			next if current_reviews.first[:review_description] == review[:review_description]
			new_reviews_to_add << review
		end
	end
	new_reviews_to_add
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
new_reviews = [{ :review_rating => "5.0 out of 5",
        		 :review_description => "Customer service was excellent and food great.",
          		 :review_dine_date => "12/01/2012"},
			   { :review_rating => "4.0 out of 5",
			     :review_description => "Got really hot waitress to give me number.",
			     :review_dine_date => "12/01/2012"},
			   { :review_rating => "2.0 out of 5",
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
          		 :review_dine_date => "1/15/2013" },
          		# essentially a direct copy of all reviews on page
          		{        :review_rating => "5.0 out of 5",
			        :review_description => "Customer service was excellent and food great.",
			          :review_dine_date => "12/01/2012"
			    },
			     {
			             :review_rating => "5.0 out of 5",
			        :review_description => "Very nice experience. Been to many fine dining restaurants around the country and this is a top contender. Great food. Great service. Attention to special details. Thanks will be back soon.",
			          :review_dine_date => "12/01/2012"
			    },
			     {
			             :review_rating => "3.0 out of 5",
			        :review_description => "Made us feel real special for my husband's birthday.",
			          :review_dine_date => "11/30/2012"
			    },
			     {
			             :review_rating => "4.0 out of 5",
			        :review_description => "I thought the ambiance was decent. There are not many windows, or exciting art pieces, but it was a classy place. The service was THE BEST!!!! Everyone rolled out the red carpet for our special day. The restaurant host was especially nice. The food was tasty as well. I didn't have steak, but my husband had it and said it was good. The prices are way too high for the amount of food served, however.",
			          :review_dine_date => "11/26/2012"
			    },
			     {
			             :review_rating => "3.0 out of 5",
			        :review_description => "Disappointed in the food and service.",
			          :review_dine_date => "11/26/2012"
			    },
			     {
			             :review_rating => "5.0 out of 5",
			        :review_description => "What a pleasant experience. We have dined on several occasions at the Mortons in Chicago but never in Troy. I had read the other reviews and found them to be mixed. Uncertain of what we might expect but it was wonderful! We started our evening with a well tended cocktail in the bar and then we were seated (on time) in a spacious booth, centrally located as we had requested in our reservation. The host was professional and welcoming. Our waiter was Patrick and he was friendly and efficient. The warm bread arrived at the table the same time we did. Our water glasses were never allowed to drop an inch below the rim. And then there was the food! We will be returning soon!!",
			          :review_dine_date => "11/24/2012"
			    },
			     {
			             :review_rating => "5.0 out of 5",
			        :review_description => "I have held two large birthday parties at this Morton's this year. The service was outstanding both times and the food was great. Highly recommend for large groups.",
			          :review_dine_date => "11/23/2012"
			    },
			     {
			             :review_rating => "5.0 out of 5",
			        :review_description => "I went to Morotns on a recomendation. Heidi was my server and I'll I can say is WOW! She was Bubbly,friendly, Knowledgable and best of all made me feel like a King. The food was terrific but I will be coming back for that great service. Just hearing Heidi tell me about my desert options made my mouth water. My beverage never went low and that usually happens to me at any resturant. I've been to high end resturants but no one else's service comes even comes close. I will definetly be returning to mortons of Troy and I would personally recomend Heidi to anyone.",
			          :review_dine_date => "11/22/2012"
			    },
			     {
			             :review_rating => "5.0 out of 5",
			        :review_description => "We love the atmosphere and service. Food is always outstanding. Everyone who works at Morton's is concerned and caring.",
			          :review_dine_date => "11/22/2012"
			    },
			     {
			             :review_rating => "5.0 out of 5",
			        :review_description => "First time going to Morton's and will not be the last time. It was fantastic!! The service was wonderful and the ambiance was awesome.",
			          :review_dine_date => "11/17/2012"
			    }
			]



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
puts "------- \n\n Current Reviews on Page \n\n-------"
ap details

puts "------- \n\n New Reviews to Test Against Previous Reviews \n\n-------"
ap new_reviews

found_reviews = check_for_new_reviews(new_reviews, details)
puts "------- \n\n Return of New Reviews with Reviews with Newer Review Dates \n\n-------"
ap found_reviews





