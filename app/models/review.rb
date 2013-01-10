class Review < ActiveRecord::Base
  scope :today, where('post_date = ?', Date.today)
  scope :yesterday, where('post_date = ?', Date.yesterday)

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
  				:url, 
  				:verified

  belongs_to :location
  belongs_to :source
end
