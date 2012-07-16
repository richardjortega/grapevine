module HttpParser
  
  #TODO: don't use silly browser agent. Try IE or something more common,
  def read_html(url)
    base_headers = {"Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
    mac_chrome_user_agent ="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.63 Safari/535.7"
    mozilla_user_agent_windows = "Mozilla/5.0 (Windows NT 5.1; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"
    ie_8_user_agent_windows = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; IPH 1.1.21.4019; .NET4.0C; .NET4.0E)"
    ie_7_user_agent_windows = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; IPH 1.1.21.4019; .NET4.0C; .NET4.0E)"
    hdrs = base_headers
    key = rand(4)
    user_agents = [mac_chrome_user_agent, mozilla_user_agent_windows, ie_8_user_agent_windows, ie_7_user_agent_windows]
    hdrs["User-Agent"] =  user_agents[key]
    my_html = ""
    #puts "url to parse location is #{url}"
    open(url, hdrs).each {|s| my_html << s}
    return my_html
  end  
end