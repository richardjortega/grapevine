require_relative "../marketinglist/upload_csv_to_db.rb"

namespace :upload do
	desc "Uploads a given CSV file to AR table: Blast"
	task :csv_of_emails => :environment do
		#Uncomment blast to delete all prior data
		puts "Dropping data from Blasts table"
		Blast.delete_all
		# Will use most recent update of the full_upload_list, keep adding to this file.
		filename = "#{Rails.root}/lib/marketinglist/filtered_lists/full_upload_list.csv"
		run = UploadMarketingList.new filename
		run.main
	end
end