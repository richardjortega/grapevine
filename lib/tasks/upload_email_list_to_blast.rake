require_relative "../marketinglist/upload_csv_to_db.rb"

namespace :upload do
	desc "Uploads a given CSV file to AR table: Blast"
	task :csv_of_emails => :environment do
		#Uncomment blast to delete all prior data
		# puts "Dropping data from Blasts table"
		# Blast.delete_all
		#Make sure to update the CSV at end of filename var in order to script to run
		filename = "#{Rails.root}/lib/marketinglist/filtered_lists/ot_portland-oregon-sa-restaurant-listings.csv"
		run = UploadMarketingList.new filename
		run.main
	end
end