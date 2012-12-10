require 'nokogiri'
require 'open-uri'
require 'pp'
require 'debugger'

class UrbanSpoon
	def initialize(location_id)
		site = 'http://www.urbanspoon.com/'
		uri = location_id
		@url = "#{site}#{uri}"
	end

	def get_new_reviews(latest_review)
		begin
		job_start_time = Time.now
		puts "Crawling: #{@url}"

		
		doc = Nokogiri::HTML(open(@url)).css('#diner_reviews ul > li.comment')
		new_reviews = []
		doc.each do |review|
			new_review = {}
			new_review[:post_date] = review.at_css('div.date.comment').children.last.text.gsub("\n","").slice(13..-1)
			
			if review.at_css('div.body a.show_more').nil?
				new_review[:comment] = review.at_css('div.body').text
			else
				new_review[:comment] = review.at_css('div.body a.show_more + span').text
			end
			
			new_review[:author] = review.at_css('div.with_stats div.title').text
			new_review[:rating] = review.at_css('div.opinion').text
			new_review[:title] = review.at_css('div.details div.title').text.gsub("\n","")
			new_reviews << new_review
		end
		puts "Total Crawl Time: #{Time.now - job_start_time} seconds"
		
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{@url} page, moving on..."
		end

		new_reviews
	end
end
