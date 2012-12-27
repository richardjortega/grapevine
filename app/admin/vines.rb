ActiveAdmin.register Vine do
  index do
  	selectable_column
  	column :source_id do |vine|
  		link_to "#{vine.source.name}", admin_source_path(vine.source)
  	end
  	column :location_id do |vine|
  		link_to "#{vine.location.name}", admin_location_path(vine.location)
  	end
  	column :source_location_uri
  	default_actions
  end
end
