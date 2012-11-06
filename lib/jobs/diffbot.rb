
require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'json'
require 'pp'
require 'debugger'
require 'open-uri'
require 'csv'
require 'HTTParty'

# class Diffbot
# 	include HTTPparty
# 	base_uri 'diffbot.com'
# 	token = "98a002f20c98dbbaf55ad956be1c3058"
# end

token = "98a002f20c98dbbaf55ad956be1c3058"

# Initial call
# 
# follow_url = 'http://www.yelp.com/biz/attaboy-burgers-san-antonio'
# response = HTTParty.post('http://www.diffbot.com/api/add', :query => { :token => token, :url => follow_url })
# pp response

dml_id = 2720249
#dml_id = 538 # cnn
response_info = HTTParty.get('http://www.diffbot.com/api/dfs/dml/archive', :query => { :token => token, :id => dml_id })
pp response_info