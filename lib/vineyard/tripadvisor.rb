require 'open-uri'
require 'nokogiri'
require 'uri'

class Tripadvisor
	def initialize
		@site = 'http://www.tripadvisor.com'
		@source = Source.find_by_name('tripadvisor')
		track_api_call
	end

	def get_location_id_status?
		false
	end

	def get_new_reviews_status?
		true
	end

	def get_location_id(term, street_address, city, state, zip)
		begin
		short_term = term.split[0..1].join(' ')
		query = "#{short_term} #{city}"
		parsed_query = URI.parse(URI.encode(query.strip))
		cx = "009410204525769731320:fiksaiphsou"
		key = "AIzaSyBZMXlt7q31RrFXUvwglhPwIIi_TabjfNU"
		path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
		response = HTTParty.get(path)
		location_id = nil
		
		debugger

		# Handle spelling errors (must be handled first)
		if response['spelling']
			puts "This query (location or address) is likely spelled wrong, please fix it."
			puts "Recommended/Corrected Query: #{response['spelling']['correctedQuery']}"
			puts "Reruning search with Corrected Query: #{response['spelling']['correctedQuery']}"
			query = "#{response['spelling']['correctedQuery']}"
			short_term = query.split[0..1].join(' ')
			parsed_query = URI.parse(URI.encode(query.strip))
			path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
			response = HTTParty.get(path)
		end

		# Handle zero results
		if response['queries']['request'][0]['totalResults'].to_i == 0
			puts "Found no results, moving on..."
			return
		end

		# Handle error responses
		if response['error']
			code = response['error']['code']
			message = response['error']['message']
			puts "Error found: #{code} | Message: #{message} | Google Search API quota may have been reached"
			return
		end

		similar_responses = 0
		results = []
		response['items'].each do |result|
			result_title = result['title']
			result_id = URI("#{result['link']}").path
			# Find if city matches up to result if not, next
			if !result_title.include?("#{city}")
				puts "This result is not in the same city as given location"
				next
			end
			if result_title.split[0..1].join(' ').include?("#{short_term}")
				puts "This location has a matching city and first word"
				puts "Found Likely Match: #{result_id} to #{term}"
				similar_responses += 1
				results << result_id
			end
		end

		if similar_responses > 1
			puts "Detected possibly similar locations in same city, rerunning with smarter query..."
			query = "#{term} #{street_address} #{city} #{state} #{zip}"
			parsed_query = URI.parse(URI.encode(query.strip))
			path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
			response = HTTParty.get(path)
			puts "We are assuming it is the first result, hopefully..."
			location_id = URI("#{response['items'][0]['link']}").path rescue "Could not find any matching information"
		else
			location_id = results.first
		end

		location_id
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered an error, moving on..."
		end
	end

	def fetch_data(location)
		source_location_uri = location.vines.find_by_source_id(@source.id).source_location_uri
		@url = "#{@site}#{source_location_uri}"
		puts "Crawling: #{@url}"
		Nokogiri::HTML(open(@url)).css('div#REVIEWS div.reviewSelector')
	end

	def get_new_reviews(location, options = {})
		begin
		latest_review_date = options[:latest_review_date] || Date.today - 2
		latest_comments = options[:latest_comments] || ''

		job_start_time = Time.now
		
		response = fetch_data(location)
		return if response.nil?

		new_reviews = compare_reviews_to_latest_reviews(response, latest_review_date, latest_comments)
		puts "Total Crawl Time: #{Time.now - job_start_time} seconds"
		new_reviews
		
		rescue => e
			pp e.message
			pp e.backtrace
			puts "Encountered error on #{@url} page, moving on..."
		end
	end

private

	def compare_reviews_to_latest_reviews(response, latest_review_date, latest_comments)
		new_reviews = []
		response.each do |review|
			review_date = Date.parse(review.at_css('span.ratingDate').text.strip.slice(9..-1))
			review_comment = review.at_css('p.partial_entry').children.first.text.strip

			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= latest_review_date
				next if latest_comments.include?(review_comment)
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review_comment
				new_review[:author] = review.at_css('div.username span').text.strip
				new_review[:rating] = review.at_css('img.sprite-ratings')[:content].to_f
				new_review[:title] = review.at_css('div.quote').text.strip.slice(1..-2)
				new_review[:url] = "#{@url}"
				new_reviews << new_review
			end
		end
		new_reviews
	end
	
	def track_api_call
		Source.update_counters(@source, :api_count_daily => 1)
	end
end