ActiveAdmin.register User do
	scope :no_stripe_customer_token
	scope :review_count_over_5
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'Users can be edited, but deletion will not delete an associating location. 
			New users must be created inside of the main web app, so that Stripe customer tokens are assigned.'
		end
		selectable_column
		column :id
		column :first_name
		column :last_name
		column :email
		column 'Associating Stripe Token' do |user|
			next if user.subscription.nil?
			"#{user.subscription.stripe_customer_token}"
		end
		column 'Associated Locations' do |user|
			next if user.locations.empty?
			locations = []
			user.locations.each do |location|
				locations << location.name
			end
			locations.join(', ')
		end
		column 'Associated Plan' do |user|
			next if user.plan.nil?
			"#{user.plan.identifier}"
		end
		column :review_count
		column :multi_location
		column :phone_number
		default_actions
	end

	form do |f|
		f.inputs 'Main' do
			f.input :first_name
			f.input :last_name
			f.input :email
			f.input :review_count
			f.input :multi_location
		end
		f.buttons
	end
end
