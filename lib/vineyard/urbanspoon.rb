require 'nokogiri'
require 'open-uri'
require 'httparty'

class UrbanSpoon
	def initialize
		@site = 'http://www.urbanspoon.com/'
	end

	def get_location_id(term, street_address, city, state, zip)
		query = "#{term} #{street_address} #{city} #{state} #{zip}"
		parsed_query = URI.parse(URI.encode(query.strip))
		cx = "009410204525769731320:oued95zmsuy"
		key = "AIzaSyAfzgIC3a-sxgoaFMZ7nZn9ioSZfwMenhM"
		path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
		response = HTTParty.get(path)
		location_id = response['items'][0]['link'] rescue "Could not find any matching information"
	end

	def get_new_reviews(latest_review, location_id)
		begin
		url = "#{@site}#{location_id}"
		job_start_time = Time.now
		puts "Crawling: #{url}"

		doc = Nokogiri::HTML(open(url)).css('.list > ul > li.comment')
		new_reviews = []

		doc.each do |review|
			review_date = Date.parse(review.at_css('div.date.comment').children.last.text.gsub("\n","").slice(13..-1))
			if review.at_css('div.body a.show_more').nil?
				review_comment = review.at_css('div.body').text.strip
			else
				review_comment = review.at_css('div.body a.show_more + span').text.strip
			end

			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= latest_review[:post_date]
				next if review_comment == latest_review[:comment].strip
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review_comment
				new_review[:author] = review.at_css('div.with_stats div.title').text.strip
				new_review[:rating] = review.at_css('div.opinion').text
				new_review[:title] = review.at_css('div.details div.title').text.strip
				new_review[:url] = url
				new_reviews << new_review
			end
		end
		puts "Total Crawl Time: #{Time.now - job_start_time} seconds"
		
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{url} page, moving on..."
		end

		new_reviews
	end
end
