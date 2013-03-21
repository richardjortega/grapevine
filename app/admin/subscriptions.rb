ActiveAdmin.register Subscription do
  filter :plan
  filter :user, :collection => proc { User.all.sort_by {|user| user.full_name.downcase} }
  filter :status
  filter :status_info
  filter :stripe_customer_token
  filter :last_four

  scope :non_active_users
  
  index do
  	selectable_column
  	column :id
  	column :user_id do |subscription|
  		link_to "#{subscription.user.first_name} #{subscription.user.last_name}", admin_user_path(subscription.user)
  	end
  	column :plan_id do |subscription|
  		"#{subscription.plan.name}"
  	end
  	column :status
  	column :status_info
  	column :stripe_customer_token
  	column :last_four
  	column :created_at
  	column :updated_at

  	default_actions
  end
end
