ActiveAdmin.register Vine do
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'Vines represent the assocation between a Location and a Source as well as the matching source_location_uri string needed for crawlers and API calls.'
		end
		selectable_column
		column :id
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
