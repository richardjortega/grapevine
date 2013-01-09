ActiveAdmin.register Relationship do
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'Relationships are the assocations between Users and their Locations, or vice versa.'
		end
		selectable_column
		column :user_id do |relationship|
			next if relationship.user.nil?
			link_to "#{relationship.user.first_name} #{relationship.user.last_name}", admin_user_path(relationship.user)
		end
		column :user_id
		column :location_id do |relationship|
			next if relationship.location.nil?
			link_to "#{relationship.location.name}", admin_location_path(relationship.location)
		end
		column :location_id
		column :created_at
		
		default_actions
	end
end
