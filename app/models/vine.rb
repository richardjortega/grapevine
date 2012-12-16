class Vine < ActiveRecord::Base
  attr_accessible :location_id, 
  				:overall_rating, 
  				:review_id, 
  				:source_id, 
  				:source_location_uri

  belongs_to :location
  belongs_to :source
  belongs_to :review
end
