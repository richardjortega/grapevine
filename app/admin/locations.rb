ActiveAdmin.register Location do
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'Adding new locations does not associate them to specific user.
			You must associate a User to a Location through the Relationships tab by creating a new Relationship.'
		end
		selectable_column
		column :id
		column :name do |location|
			link_to "#{location.name}", admin_location_path(location)
		end
		column 'Associated Users' do |location|
			next if location.users.empty?
			users = []
			location.users.each do |user|
				users << user.display_name
			end
			users.join(', ')
		end

		column 'Associated Vines' do |location|
			next if location.vines.empty?
			vines = []
			location.vines.each do |vine|
				vines << vine.source.name
			end
			vines.join(', ')
		end

		column :street_address
		column :address_line_2
		column :city
		column :state
		column :zip
		column :lat
		column :long
		column :uri_check_date
		column :created_at
		default_actions
	end
  
end
