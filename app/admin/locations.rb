ActiveAdmin.register Location do
	index do
		selectable_column
		column :name do |location|
			link_to "#{location.name}", admin_location_path(location)
		end
		column :street_address
		column :address_line_2
		column :city
		column :state
		column :zip
		column :lat
		column :long
		column :created_at
		default_actions
	end
  
end
