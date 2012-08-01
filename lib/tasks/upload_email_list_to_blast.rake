require_relative "../marketinglist/upload_csv_to_db.rb"

namespace :upload do
	desc "Uploads a given CSV file to AR table: Blast"
	task :csv_of_emails => :environment do
		puts "Dropping data from Blasts table"
		Blast.delete_all
		filename = "#{Rails.root}/lib/marketinglist/opentable_restaurants-sw-w-filtered.csv"
		run = UploadMarketingList.new filename
		run.main
	end
end