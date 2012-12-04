class Review < ActiveRecord::Base
  attr_accessible :author, 
  				  :author_url, 
  				  :comment, 
  				  :location_id, 
  				  :management_response, 
  				  :post_date, 
  				  :rating, 
  				  :rating_description, 
  				  :source_id, 
  				  :title, 
  				  :verified

  belongs_to :location
  belongs_to :source
end
