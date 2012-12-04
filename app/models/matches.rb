class Matches < ActiveRecord::Base
  attr_accessible :overall_rating, 
  				  :review_id, 
  				  :source_id, 
  				  :source_refer_id
  belongs_to :location
  belongs_to :source
end
