require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'debugger'
require 'ap'
require 'watir-webdriver'

cid = '105450966021239914426'
url = "https://plus.google.com/#{cid}/about?gl=US&hl=en-US"

doc = Nokogiri::HTML(browser.html)
puts url, doc.at_css("title").text, "====================="

reviews = Array.new

doc.xpath("//*[@id=\"#{cid}-about-page\"]/div[1]/div[1]/div[3]/div[2]/div/div/div[2]").each do |review|
  parsed_review = {}
  parsed_review[:review] = review.xpath('div[2]').text
  parsed_review[:author] = review.xpath('span[1]').text
  parsed_review[:decor] =  review.xpath('div[1]/span[2]/span[2]').text
  parsed_review[:atmosphere] = review.xpath('div[1]/span[1]/span[2]').text
  parsed_review[:service] = review.xpath('div[1]/span[3]/span[2]').text
  reviews << parsed_review
end

ap reviews