ActiveAdmin.register Source do
  index do
  	selectable_column
  	column :name
  	column :category
  	column :max_rating
  	column :accepts_management_response
  	column :management_response_url
  	column :main_url
    column :api_count_daily
    column :api_count_all_time
  	default_actions
  end
end
