class Plan < ActiveRecord::Base
	extend FriendlyId

	friendly_id :name, :use => :slugged

	# Association
	has_many :subscriptions

	validates :name,	presence: true, uniqueness: true
	validates :slug, 	presence: true, uniqueness: true
	validates :amount,	presence: true, numbericality: { greater_than_or_equal_to: 0 }

	attr_accessible :amount, :currency, :interval, :name, :slug


end
