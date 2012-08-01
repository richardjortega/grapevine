require 'csv'
require 'rubygems'
require_relative "../../app/models/blast"

class UploadMarketingList
    def initialize(filename)
        @filename = filename
    end
    def main
        CSV.foreach(@filename, :encoding => 'windows-1251:utf-8') do |row|
            record = Blast.new(
                :name               => row[0], 
                :url                => row[1],
                :rating             => row[2],
                :address            => row[3],
                :total_reviews      => row[4],
                :cuisine            => row[5],
                :price              => row[6],
                :neighborhood       => row[7],
                :website            => row[8],
                :email              => row[9],
                :phone              => row[10],
                :review_rating      => row[11],
                :review_description => row[12],
                :review_dine_date   => row[13],
                :marketing_url      => row[14],
                :marketing_id       => row[15]
            )
            puts "Saved #{record.marketing_id} : #{record.name} into the Blast table"
            record.save!
        end
    end
end
    

