require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'uri'

class Urbanspoon
	def initialize
		@site = 'http://www.urbanspoon.com'
		@source = Source.find_by_name('urbanspoon')
		track_api_call
	end

	def get_location_id(term, street_address, city, state, zip, lat, long)
		begin
		query = "#{term} #{street_address} #{city} #{state} #{zip}"
		parsed_query = URI.parse(URI.encode(query.strip))
		cx = "009410204525769731320:oued95zmsuy"
		key = "AIzaSyBZMXlt7q31RrFXUvwglhPwIIi_TabjfNU"
		path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
		response = HTTParty.get(path)
		location_id = nil

		# Handle spelling errors (must be handled first)
		if response['spelling']
			puts "This query (location or address) is likely spelled wrong, please fix it."
			puts "Recommended/Corrected Query: #{response['spelling']['correctedQuery']}"
			puts "Reruning search with Corrected Query: #{response['spelling']['correctedQuery']}"
			query = "#{response['spelling']['correctedQuery']}"
			parsed_query = URI.parse(URI.encode(query.strip))
			path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
			response = HTTParty.get(path)
		end

		# Handle zero results
		if response['queries']['request'][0]['totalResults'].to_i == 0
			puts "Found no results. Rerunning with simpler query: '#{term} #{city}'"
			query = "#{term} #{city}"
			parsed_query = URI.parse(URI.encode(query.strip))
			path = "https://www.googleapis.com/customsearch/v1?q=#{parsed_query}&cx=#{cx}&key=#{key}"
			response = HTTParty.get(path)
			if response['queries']['request'][0]['totalResults'].to_i == 0
				puts "Found no results, moving on..."
				return
			end
		end

		# Handle error responses
		if response['error']
			code = response['error']['code']
			message = response['error']['message']
			puts "Error found: #{code} | Message: #{message} | Google Search API quota may have been reached"
			return
		end
		# Check each location
		response['items'].each do |result|
			#Check lat and long against lat and long of resulted
			if result['pagemap'].present?
				result_lat = result['pagemap']['metatags'][0]['urbanspoon:location:latitude'].to_f 
				result_long = result['pagemap']['metatags'][0]['urbanspoon:location:longitude'].to_f
				result_id = URI("#{result['link']}").path
				result_name = result['title']
				delta = Geocoder::Calculations.distance_between([lat.to_f,long.to_f],[result_lat,result_long])

				if delta < 0.25
					location_id = result_id rescue "Could not find any matching information"
					break
				else
					puts "Found a search result that is too far away from asking location. Distance is #{delta} miles"
				end
			else
				# This kind of result may need proper parsing and removing of url params
				uri = URI("#{result['link']}")
				location_id = uri.path
			end
		end
		# If no results match what we are looking for 'location_id' will return nil
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
		Nokogiri::HTML(open(@url)).css('.list > ul > li.comment')
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
			review_date = Date.parse(review.at_css('div.date.comment').children.last.text.gsub("\n","").slice(13..-1))
			if review.at_css('div.body a.show_more').nil?
				review_comment = review.at_css('div.body').text.strip
			else
				review_comment = review.at_css('div.body a.show_more + span').text.strip
			end

			# when review_date is taking date objects, change this to just 'if review_date >= latest_review[:post_date]'
			if review_date >= latest_review_date
				next if latest_comments.include?(review_comment)
				new_review = {}
				new_review[:post_date] = review_date
				new_review[:comment] = review_comment
				new_review[:author] = review.at_css('div.with_stats div.title').text.strip
				if review.at_css('div.opinion').present?
					new_review[:rating] = review.at_css('div.opinion').text
				end
				new_review[:title] = review.at_css('div.details div.title').text.strip
				new_review[:url] = @url
				new_reviews << new_review
			end
		end
		new_reviews
	end

	def track_api_call
		Source.update_counters(@source, :api_count_daily => 1)
	end

end
