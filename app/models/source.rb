class Source < ActiveRecord::Base
  attr_accessible :accepts_management_response, 
  				:category, 
  				:main_url, 
  				:management_response_url, 
  				:max_rating, 
  				:name

  has_many :vines
  has_many :locations, through: :vines
  has_many :reviews, through: :vines
end
