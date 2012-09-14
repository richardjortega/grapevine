require 'net/http'
require 'json'
require 'ap'
require 'debugger'

#def new_egg
	page_number = 0
	max_page_number = 0
	all_products = []
	while page_number <= max_page_number
		http = Net::HTTP.new("www.ows.newegg.com")
		http.post2('/Search.egg/Advanced', "{\"BrandId\":1459, \"PageNumber\":#{page_number}}")
		puts page_number
		response = http.post2('/Search.egg/Advanced', "{\"BrandId\":1459, \"PageNumber\":#{page_number}}")
		products = JSON.parse(response.body)

		total_products = products["PaginationInfo"]["TotalCount"].to_i
		max_page_number = (total_products / 20) + 1

		products["ProductListItems"].each do |product|
			parsed_product = {}
			# debugger
			parsed_product[:NEIN] = product["NeweggItemNumber"]
			parsed_product[:total_reviews] = product["ReviewSummary"]["TotalReviews"]
			parsed_product[:rating] = product["ReviewSummary"]["Rating"]
			parsed_product[:title] = product["Title"]
			parsed_product[:model] = product["Model"]
			parsed_product[:item_number] = product["ItemNumber"]
			all_products << parsed_product
		end
		page_number += 1
	end
	puts all_products

#end

# ap rich