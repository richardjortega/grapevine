class Subscription < ActiveRecord::Base
  
  attr_accessor :stripe_card_token

  attr_accessible :card_expiration, :card_type, :card_zip, :current_period_end, :current_period_start, :last_four, :next_bill_on, :plan_id, :status, :stripe_customer_token, :trial_end, :trial_start, :user_id

  belongs_to :plan
  belongs_to :user

  validates :plan_id,				presence: true
  validates :user_id, 				presence: true, uniqueness: true
  validates :stripe_customer_token,	presence: true

  

  def save_without_payment # 30 Day Free Trial Signups
  	customer = stripe_customer_without_credit_card
  	self.stripe_customer_token	= customer.id
  	# This will not create a stripe charge at all
  	# This assigns user to Grapevine Alerts - Monthly Alerts
  	customer.update_subscription({:plan => "basic_monthly"})
  end



private
	def stripe_description
	  	"#{user.name}: #{user.email}"
	end

	def stripe_customer_without_credit_card
		Stripe::Customer.create email: user.email, plan: plan.identifier, description: stripe_description
	end

	# def set_card_info new_card
	# 	self.last_four		 = new_card.last4
	# 	self.card_type		 = new_card.type
	# 	self.card_expiration = "#{ new_card.exp_month }-#{ new_card.exp_year }"
	# end

	# def stripe_customer
	# 	@stripe_customer ||= Stripe::Customer.retrieve stripe_customer_token
	# end

end
