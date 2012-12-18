class Vine < ActiveRecord::Base
  attr_accessible :location_id, 
  				:overall_rating, 
  				:source_id, 
  				:source_location_uri

  belongs_to :location
  belongs_to :source

end
