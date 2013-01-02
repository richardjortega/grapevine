class Plan < ActiveRecord::Base
	# Association
	has_many :subscriptions

	validates :name,	presence: true, uniqueness: true
	validates :identifier, 	presence: true, uniqueness: true
	validates :amount,	presence: true, numericality: { greater_than_or_equal_to: 0 }

	attr_accessible :amount, 
				:currency, 
				:interval, 
				:name, 
				:identifier, 
				:trial_period_days,
				:location_limit,
				:review_limit


end
