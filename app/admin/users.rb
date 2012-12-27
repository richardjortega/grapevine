ActiveAdmin.register User do
  index do
  	selectable_column
  	column :first_name
  	column :last_name
  	column :email
  	column :phone_number
  	default_actions
  end
end
