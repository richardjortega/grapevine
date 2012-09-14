require 'rubygems'
require 'nokogiri'
require 'open-uri'
# require 'ap'
require 'json'
require 'csv'
require 'HTTParty'

# sample product review page
# http://www.ows.newegg.com/Products.egg/N82E16820145579/reviews

# sample json request for product pages - one page only
# curl  -X POST -d '{"BrandId":1459, "PageNumber":0}' http://www.ows.newegg.com/Search.egg/Advanced > results.json


def parse_product_listing(link)
	doc = Nokogiri::HTML(open(link)).css('div#all_menu_list_content ul li a')
	doc.collect do |listing|
		parse_listing(listing)
	end
end

def parse_listing(listing)
	puts listing.attributes["href"].text
	#listing.children.first.attributes["href"].text
end

def parse_product_page(prod_id)
	url = "http://www.ows.newegg.com/Products.egg/#{prod_id}/reviews"
	# url = "http://www.ows.newegg.com/Products.egg/N82E16820145579/reviews"
	puts url
	response = HTTParty.get(url)
	response["Reviews"].each do |data|
		parsed_review = Hash.new
		parsed_review[:title] = data["Title"]
		parsed_review[:rating] = data["Rating"]
		parsed_review[:cons] = data["Cons"]
		parsed_review[:pros] = data["Pros"]
		parsed_review[:comments] = data["Comments"]
		puts parsed_review
	end
end

parse_product_listing("http://www.newegg.com/Store/Brand.aspx?Brand=1459&name=Corsair")

