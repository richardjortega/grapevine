ActiveAdmin.register Review do
  index do
  	selectable_column
  	column :author
  	column :author_url
  	column :comment do |review|
  		truncate("#{review.comment}", :length => 50)
  	end
  	column :post_date
  	column :rating
  	column :title
  	column :rating_description
  	column :author_url
  	column :created_at
  	default_actions
  end
end
