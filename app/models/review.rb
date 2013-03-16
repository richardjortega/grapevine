class Review < ActiveRecord::Base
  scope :today_post_date, where('post_date = ?', Date.today)
  scope :yesterday_post_date, where('post_date = ?', Date.yesterday)
  scope :new_reviews, where('status = ?', 'new').order('created_at DESC')
  scope :sent_reviews, where('status = ?', 'sent').order('status_updated_at DESC')
  scope :archive_reviews, where('status = ?', 'archive').order('status_updated_at DESC')

  scope :last_month_reviews, where(:post_date => Date.today.prev_month.beginning_of_month..Date.today.prev_month.end_of_month).order(:post_date).reverse_order
  scope :this_month_reviews, where(:post_date => Date.today.beginning_of_month..Date.today).order(:post_date).reverse_order
  scope :last_two_weeks_reviews, where(:post_date => 2.weeks.ago..Date.today).order(:post_date).reverse_order

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
