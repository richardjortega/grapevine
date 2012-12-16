class Review < ActiveRecord::Base
  attr_accessible :author, 
  				:author_url, 
  				:comment, 
  				:management_response, 
  				:post_date, 
  				:rating, :rating_description, :title, :url, :verified
  has_one :vine
  has_one :location, through: :vine

  belongs_to :source, through: :vines
end
