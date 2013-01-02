ActiveAdmin.register Subscription do
  actions :index, :show
  index do
  	selectable_column
  	column :id
  	column :user_id do |subscription|
  		link_to "#{subscription.user.first_name} #{subscription.user.last_name}", admin_user_path(subscription.user)
  	end
  	column :plan_id do |subscription|
  		link_to "#{subscription.plan.name}", admin_plan_path(subscription.plan)
  	end
  	column :status
  	column :status_info
  	column :stripe_customer_token
  	column :last_four
  	column :next_bill_on
  	column :card_expiration
  	column :current_period_start
  	column :current_period_end
  	column :trial_start
  	column :trial_end
  	column :created_at
  	column :updated_at

  	default_actions
  end
end
