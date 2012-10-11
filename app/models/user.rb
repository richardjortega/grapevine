class User < ActiveRecord::Base

  # Pre-validators!
  before_save :format_phone_number

  # Associations
  has_one :subscription, dependent: :destroy
  has_one :plan, through: :subscription
  has_many :relationships, dependent: :destroy
  has_many :locations, through: :relationships
  accepts_nested_attributes_for :locations

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :email_regexp => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name,
                  :last_name, 
                  :email, 
                  :password, 
                  :password_confirmation, 
                  :remember_me, 
                  :stripe_token,
                  :phone_number,
                  :location,
                  :locations_attributes

  validates_presence_of :email
  validates_presence_of :password, :on => :create
  validates_length_of :password, :minimum => 6
  validates_confirmation_of :password
  validates_uniqueness_of :email, :case_sensitive => false

private

  def format_phone_number
    #will remove all but integers, only if a phone number has been provided
    self.phone_number = self.phone_number.gsub(/[^0-9]/,"") if self.phone_number.present?
  end


end
