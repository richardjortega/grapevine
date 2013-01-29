ActiveAdmin.register Review do
	#actions :index, :show
	scope :all, :default => true
	scope :today
	scope :yesterday
	scope :new_reviews
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'This page is not directly editable, reviews should be handled by our crawlers (if you see errors report them)!'
		end
		selectable_column
		column :id
		column :location do |review|
			"#{review.location.name}"
		end
		column :source do |review|
			"#{review.source.name}"
		end
		column :author
		column :author_url
		column :comment do |review|
			truncate("#{review.comment}", :length => 50)
		end
		column :post_date
		column :rating
		column :title
		column :rating_description
		column :status
		column :author_url
		column :created_at
		default_actions
	end
end
