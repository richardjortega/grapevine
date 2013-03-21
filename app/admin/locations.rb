ActiveAdmin.register Location do
	
	#views
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
			link_to "Vines (#{vines.join(', ')})", :controller => "vines", :action => "index", 'q[location_id_eq]' => "#{location.id}".html_safe 
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

	show do |location|
      attributes_table do
      	row :id
      	row :name
      	row :street_address
      	row :address_line_2
      	row :city
      	row :state
      	row :zip
      	row :website
      	row :lat
      	row :long
      	row 'Vines' do |location|
      		next if location.vines.empty?
			vines = []
			location.vines.each do |vine|
				vines << vine.source.name
			end
			link_to "Vines (#{vines.join(', ')})", :controller => "vines", :action => "index", 'q[location_id_eq]' => "#{location.id}".html_safe 
      	end
      	row :uri_check_date
      	row :created_at
      	row :updated_at

        # row :image do
        #   image_tag(vine.image.url)
        # end
      end
      active_admin_comments
    end
  
end
