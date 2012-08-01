Rails.env = 'development'
require 'database_cleaner'
namespace :db do
	desc "Cleans and truncates entire database - Dev ENV only"
	task :clean do
		# whipe a hoe db!
		DatabaseCleaner.strategy = :truncation
		# then, whenever you need to clean the DB
		DatabaseCleaner.clean
	end
end



 