class Subscription < ActiveRecord::Base
  
  attr_accessor :stripe_card_token

  attr_accessible :card_expiration, 
                  :card_type, 
                  :card_zip, 
                  :current_period_end, 
                  :current_period_start, 
                  :last_four, 
                  :next_bill_on, 
                  :plan_id, 
                  :status, 
                  :stripe_customer_token, 
                  :trial_end, 
                  :trial_start, 
                  :user_id

  belongs_to :plan
  belongs_to :user

  validates :plan_id,				presence: true
  validates :user_id, 				presence: true, uniqueness: true
  validates :stripe_customer_token,	presence: true

  
  # Create new customer on Stripe and internal, 30 Day Free Trial Signups
  def save_without_payment 
  	customer = stripe_customer_without_credit_card 
  	self.stripe_customer_token	= customer.id
  	# This will not create a stripe charge at all
  	# This assigns user to Grapevine Alerts - Monthly Alerts
  	customer.update_subscription({:plan => "basic_monthly"})
  	self.status = true
    self.status_info = "trialing"
    self.start_date = Date.today
  	save!
  end

  def save_with_payment
    if valid?
      customer = stripe_customer_with_credit_card
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def update_stripe
    # if stripe_customer_token.nil?
    #   if !stripe_token.present?
    #     raise "We're doing something wrong -- this isn't supposed to happen"
    #   end

    #   customer = Stripe::Customer.create(
    #     :email => email,
    #     :description => stripe_description,
    #     :card => stripe_token
    #   )
    #   self.last_four = customer.active_card.last4
    #   response = customer.update_subscription({:plan => "premium"})
    # else
      customer = Stripe::Customer.retrieve(stripe_customer_token)

      if stripe_card_token.present?
        customer.card = stripe_card_token
      end

      # in case they've changed
      customer.email = user.email
      customer.description = stripe_description
      debugger
      customer.save

      self.last_four = customer.active_card.last4
    # end

    self.stripe_customer_token = customer.id
    self.stripe_token = nil
  end



private
	def stripe_description
	  	"#{user.first_name} #{user.last_name}: #{user.email}"
	end

	def stripe_customer_without_credit_card
		Stripe::Customer.create email: user.email, plan: plan.identifier, description: stripe_description
  end

  def stripe_customer_with_credit_card
    Stripe::Customer.create(email: user.email, description: stripe_description, plan: plan.identifier, card: stripe_card_token)
  end

	def stripe_customer
		@stripe_customer ||= Stripe::Customer.retrieve stripe_customer_token
	end

end
