class Source < ActiveRecord::Base
  attr_accessible :accepts_management_response, 
  				:category, 
  				:main_url, 
  				:management_response_url, 
  				:max_rating, 
  				:name

  has_many :matches
  has_many :locations, through: :matches

  has_many :vines
  has_many :reviews, through: :vines
end
