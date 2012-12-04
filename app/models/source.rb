class Source < ActiveRecord::Base
  attr_accessible :category, 
  				  :main_url, 
  				  :management_response_url, 
  				  :max_rating, 
  				  :name
  has_many :locations, through: :matches
  has_many :reviews
end
