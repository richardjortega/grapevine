ActiveAdmin.register Relationship do
	filter :user, :collection => proc { User.all.sort_by {|user| user.full_name.downcase} }
	filter :location, :collection => proc { Location.all.sort_by {|location| location.name.downcase} }
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'Relationships are the assocations between Users and their Locations, or vice versa.'
		end
		selectable_column
		column :user_id do |relationship|
			next if relationship.user.nil?
			link_to "#{relationship.user.display_name}", admin_user_path(relationship.user)
		end
		column :user_id
		column :location_id do |relationship|
			next if relationship.location.nil?
			link_to "#{relationship.location.name}", admin_location_path(relationship.location)
		end
		column :location_id
		column 'Associated Vines' do |relationship|
			next if relationship.location.nil? or relationship.location.vines.empty?
			vines = []
			relationship.location.vines.each do |vine|
				vines << vine.source.name
			end
			vines.join(', ')
		end
		column 'Vine Count' do |relationship|
			next if relationship.location.nil?
			link_to "#{relationship.location.vines.count}", :controller => 'vines', :action => 'index', 'q[location_id_eq]' => "#{relationship.id}".html_safe
		end
		column :created_at
		
		default_actions
	end

	form do |f|
    f.inputs "New Relationship" do
        f.input :user_id, :as => :select, :collection => User.all.sort_by {|user| user.full_name.downcase}
        f.input :location_id, :as => :select, :collection => Location.all.sort_by {|location| location.name.downcase}
    end
end
end
