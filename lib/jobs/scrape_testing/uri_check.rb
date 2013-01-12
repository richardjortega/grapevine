require 'rubygems'
require 'mechanize'
require 'debugger'

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

a.get('http://google.com/') do |page|
	debugger
  search_result = page.form_with(:name => 'q') do |search|
    search.q = 'Hello world'
  end.submit

  search_result.links.each do |link|
    puts link.text
  end
end