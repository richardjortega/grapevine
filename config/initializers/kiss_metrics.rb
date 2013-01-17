Lascivious.setup do |config|
  if Rails.env == 'production'
    config.api_key = ENV['KISS_METRICS_API_KEY']
  else
    # Development/testing/staging account key...
    config.api_key = "de0b51786a475f40e1ceef4684a1f18808e16645"
  end
end