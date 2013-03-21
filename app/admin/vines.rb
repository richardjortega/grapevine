ActiveAdmin.register Vine do
	scope :all, :default => true
	scope :locations_without_uris
	filter :location, :collection => proc { Location.all.sort_by {|location| location.name.downcase} }
	filter :source, :collection => proc { Source.all.sort_by {|source| source.name.downcase} }

	#views
	index do
		h2 :style => "line-height:26px; width:65%;" do 
			'Vines represent the assocation between a Location and a Source as well as the matching source_location_uri string needed for crawlers and API calls.'
		end

		h3 link_to 'Examples for how to create vines properly', admin_help_path

		selectable_column
		column :id
		column :source_id do |vine|
			next if vine.source.nil?
			link_to "#{vine.source.name}", admin_source_path(vine.source)
		end
		column :location_id do |vine|
			next if vine.location.nil?
			link_to "#{vine.location.name}", admin_location_path(vine.location)
		end
		column :source_location_uri  do |vine|
			if vine.source.name == 'googleplus'
				truncate("#{vine.source_location_uri}", :length => 50)
			else
				vine.source_location_uri
			end
		end
		default_actions
	end
	
	form do |f|
		f.inputs 'Location' do
			f.input :location, :as => :select, :collection => Location.all.sort_by {|location| location.name.downcase}
			f.input :source, :as => :select
			f.input :source_location_uri
			f.input :overall_rating
		end
		f.buttons
	end
end
