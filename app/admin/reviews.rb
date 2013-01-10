ActiveAdmin.register Review do
	#actions :index, :show
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'This page is not directly editable, reviews should be handled by our crawlers (if you see errors report them)!'
		end
		selectable_column
		column :id
		column :location do |review|
			link_to "#{review.location.name}", admin_location_path(review.location)
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
		column :author_url
		column :created_at
		default_actions
	end
end
