class Vine < ActiveRecord::Base
  attr_accessible :location_id, 
  				:overall_rating, 
  				:source_id, 
  				:source_location_uri

  belongs_to :location
  belongs_to :source
  scope :locations_without_uris, where(:source_location_uri => nil, :source_location_uri => '')
end
