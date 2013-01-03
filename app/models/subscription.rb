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

  validates :plan_id,	presence: true
  validates :user_id, presence: true, uniqueness: true
  validates :stripe_customer_token,	presence: true

  
  # Create new customer on Stripe and internal, 30 Day Free Trial Signups
  def save_without_payment 
    customer = stripe_customer_without_credit_card 
  	self.stripe_customer_token	= customer.id
  	# This will not create a stripe charge at all
  	# This assigns user to Grapevine Alerts - Monthly Alerts
  	customer.update_subscription({:plan => "gv_free"})
  	self.status                 = true
    self.status_info            = "active"
    self.next_bill_on           = Date.parse customer.next_recurring_charge.date
    self.start_date             = Date.today.beginning_of_day.to_i
  	user.save!
    save!
  end

  def save_with_payment
    if valid?
      customer = stripe_customer_with_credit_card
      self.stripe_customer_token = customer.id
      self.next_bill_on          = Date.parse customer.next_recurring_charge.date
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def update_stripe params
    begin
    customer = Stripe::Customer.retrieve(stripe_customer_token)

    # Before adding a plan, we are ensuring that the user has a credit card associated (needed for paid plans)
    if params[:stripe_card_token].present?
      if user.plan.identifier == 'gv_free'
        customer = stripe_customer_with_credit_card params
      else
        customer.card = params[:stripe_card_token]
      end 
    end

    if params[:plan].present?
      customer.update_subscription({:plan => params[:plan]})
      user_new_plan = Plan.find_by_identifier params[:plan]
      user.plan = user_new_plan
    end

    # in case they've changed
    customer.email             = user.email
    customer.description       = stripe_description
    customer.save

    self.last_four             = params[:last_four]
    self.status_info           = "active"
    self.next_bill_on          = Date.parse customer.next_recurring_charge.date
    self.stripe_customer_token = customer.id
    user.save!
    save!

    rescue Stripe::InvalidRequestError => e
      puts "#{e.message}"    
    end
  end



private
	def stripe_description
	  	"#{user.first_name} #{user.last_name}: #{user.email}"
	end

  def end_trial customer
    set_trial_end = Time.now.utc + 5
    current_plan  = customer.subscription.plan.id
    customer.update_subscription(:plan => current_plan, :trial_end => set_trial_end.to_i)

  end

	def stripe_customer_without_credit_card
		Stripe::Customer.create email: user.email, plan: plan.identifier, description: stripe_description
  end

  def stripe_customer_with_credit_card params
    Stripe::Customer.create(email: user.email, description: stripe_description, plan: params[:plan], card: params[:stripe_card_token])
  end

	def stripe_customer
		@stripe_customer ||= Stripe::Customer.retrieve stripe_customer_token
	end

end
