class Vine < ActiveRecord::Base
  attr_accessible :location_id, 
  				:review_id, 
  				:source_id
  				
  belongs_to :location
  belongs_to :source
  belongs_to :review
end
