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
		puts "Scrapping: #{@url}"

		
		doc = Nokogiri::HTML(open(@url)).css('#diner_reviews ul > li.comment')
		new_reviews = []
		doc.each do |review|
			debugger
			new_review = {}
			new_review[:post_date] = ''
			new_review[:comment] = ''
			new_review[:author] = ''
			new_review[:rating] = ''
			new_review[:title] = ''
			new_reviews << new_review
		end

		puts "Total Time: #{Time.now - job_start_time} seconds"
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{@url} page, moving on..."
			# Nil values handled in parser with Array#compact
		end	


	end

end
