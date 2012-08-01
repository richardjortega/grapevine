class Blast < ActiveRecord::Base
  attr_accessible :address, :cuisine, :email, :marketing_id, :marketing_url, :name, :neighborhood, :phone, :price, :review_description, :review_dine_date, :review_rating, :total_reviews, :url, :website, :rating
end