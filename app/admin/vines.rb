ActiveAdmin.register Vine do
  index do
  	selectable_column
  	column :source_id do |vine|
  		link_to "#{vine.source.name}", "/admin/sources/#{vine.source_id}"
  	end
  	column :location_id do |vine|
  		link_to "#{vine.location.name}", "/admin/locations/#{vine.location_id}"
  	end
  	column :source_location_uri
  	default_actions
  end
end
