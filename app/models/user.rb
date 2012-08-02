class User < ActiveRecord::Base

  # Associations
  has_one :subscription
  has_one :plan, :through => :subscription
  has_many :relationships
  has_many :locations, :through => :relationships
  accepts_nested_attributes_for :locations, :subscription

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name,
                  :last_name, 
                  :email, 
                  :password, 
                  :password_confirmation, 
                  :remember_me, 
                  :stripe_token,
                  :phone_number,
                  :plan_id
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_uniqueness_of :email

end
