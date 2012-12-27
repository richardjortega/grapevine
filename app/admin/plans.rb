ActiveAdmin.register Plan do
  actions :index
  index do
  	h2 :style => "line-height:26px; width:65%;" do 
  		'This page is not directly editable, plans must be created and updated at Stripe. Changes will then be reflected in our system (soon!, needs to be)'
  	end
  	column :name
  	column :identifier
  	column :amount do |plan|
		# Converts cents to dollars
		sprintf('$%0.2f', plan.amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")	
  	end
  	column :currency
  	column :interval
  	column :trial_period_days
  	column :location_limit
  	column :review_limit
  	column :created_at
  	column :updated_at
  end
end
