class Source < ActiveRecord::Base
  attr_accessible :accepts_management_response, 
  				:category, 
  				:main_url, 
  				:management_response_url, 
  				:max_rating, 
  				:name,
          :api_count_daily,
          :api_count_all_time,
          :hex_value

  has_many :vines
  has_many :locations, through: :vines

  has_many :reviews

  validates_uniqueness_of :name, :case_sensitive => false

end
