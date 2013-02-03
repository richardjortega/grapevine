ActiveAdmin.register Review do
	#actions :index, :show
	batch_action :mark_new, :confirm => "Are you sure you want to mark all reviews as new again? They will be sent in next blast run." do |selection|
		Review.find(selection).each do |review|
			review.status = 'new'
			review.status_updated_at = Time.now
			review.save!
		end
		redirect_to :back  #this ensures any current filter stays active
	end

	scope :all, :default => true
	scope :today_post_date
	scope :yesterday_post_date
	scope :new_reviews
	scope :sent_reviews
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'This page is not directly editable, reviews should be handled by our crawlers (if you see errors report them)!'
		end
		selectable_column
		column :id
		column :location do |review|
			"#{review.location.name}"
		end
		column 'Associated Users' do |review|
			next if review.location.users.empty?
			users = []
			review.location.users.each do |user|
				users << user.display_name
			end
			users.join(', ')
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
		column :updated_at
		column :status_updated_at
		default_actions
	end
end
