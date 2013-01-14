require 'raven'

Raven.configure do |config|
    config.dsn = 'SENTRY_DSN'
end