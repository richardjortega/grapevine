class Subscription < ActiveRecord::Base

  scope :non_active_users, where('status_info != ?', 'active')
  
  attr_accessor :stripe_card_token

  attr_accessible :card_type,  
                  :current_period_end, 
                  :current_period_start, 
                  :last_four, 
                  :next_bill_on, 
                  :plan_id, 
                  :status, 
                  :stripe_customer_token, 
                  :trial_end, 
                  :trial_start, 
                  :user_id,
                  :exp_month,
                  :exp_year,
                  :status_info,
                  :start_date

  belongs_to :plan
  belongs_to :user

  validates :plan_id,	presence: true
  validates :user_id, presence: true, uniqueness: true
  validates :stripe_customer_token,	presence: true

  
  
  def save_without_payment
    # Create new customer on Stripe and internal for free account 
    customer = stripe_customer_without_credit_card 
  	self.stripe_customer_token	= customer.id

    # Check for clients that need to pay immediately
    if self.plan.identifier == 'gv_needs_to_pay'
      self.status_info = 'unpaid'
    else
      self.status = true
      self.status_info = 'active'
    end

    self.start_date             = Date.today.beginning_of_day.to_i
  	user.save!
    save!
  end

  # Used for any updating of users on Stripe after user has signed up
  def update_stripe params
    begin
    customer = Stripe::Customer.retrieve(stripe_customer_token)

    # If user is upgrading their free plan to paid plan
    if params[:stripe_card_token].present? && params[:plan].present?
      customer.update_subscription({:card => params[:stripe_card_token], :plan => params[:plan]})
      user.plan = Plan.find_by_identifier params[:plan]  
    end

    # User updated credit card but doesn't change their plan
    if params[:stripe_card_token].present? && !params[:plan].present?
      customer.update_subscription({:card => params[:stripe_card_token]})
    end

    # User changes plan (provided they have a credit card on file)
    if params[:plan].present? && !params[:stripe_card_token].present?
      customer.update_subscription({:plan => params[:plan]})
      user.plan = Plan.find_by_identifier params[:plan]
    end

    # in case they've changed
    customer.email             = user.email
    customer.description       = stripe_description
    customer.save

    if params[:exp_month].present?
      self.exp_month = params[:exp_month]
    end

    if params[:exp_year].present?
      self.exp_year = params[:exp_year]
    end
    
    self.last_four             = params[:last_four]
    self.status_info           = "active"
    self.status                = true
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

	def stripe_customer
		@stripe_customer ||= Stripe::Customer.retrieve stripe_customer_token
	end

end
