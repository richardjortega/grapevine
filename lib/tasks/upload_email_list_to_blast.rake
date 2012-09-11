require_relative "../marketinglist/upload_csv_to_db.rb"

namespace :upload do
	desc "Uploads a given CSV file to AR table: Blast"
	task :csv_of_emails => :environment do
		puts "Dropping data from Blasts table"
		#Uncomment blast to delete all prior data
		#Blast.delete_all
		#Make sure to update the CSV at end of filename var in order to script to run
		filename = "#{Rails.root}/lib/marketinglist/filtered_lists/opentable.com_central-coast-tahoe-restaurant-listings.csv"
		run = UploadMarketingList.new filename
		run.main
	end
end