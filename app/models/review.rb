class Review < ActiveRecord::Base
  scope :today, where('post_date = ?', Date.today)
  scope :yesterday, where('post_date = ?', Date.yesterday)
  scope :new_reviews, where('status = ?', 'new').order('created_at DESC')
  scope :sent_reviews, where('status = ?', 'sent').order('status_updated_at DESC')

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
  				:verified,
          :status,
          :status_updated_at

  belongs_to :location
  belongs_to :source
end
