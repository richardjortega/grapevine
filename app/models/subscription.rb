class Subscription < ActiveRecord::Base
  
  attr_accessor :stripe_card_token

  attr_accessible :card_expiration, :card_type, :card_zip, :current_period_end, :current_period_start, :last_four, :next_bill_on, :plan_id, :status, :stripe_customer_token, :trial_end, :trial_start, :user_id

  belongs_to :plan
  belongs_to :user

  validates :plan_id,				presence: true
  validates :user_id, 				presence: true, uniqueness: true
  validates :stripe_customer_token,	presence: true
end
