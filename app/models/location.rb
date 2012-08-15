class Location < ActiveRecord::Base
  attr_accessible :address_line_2, :city, :lat, :long, :name, :state, :street_address, :website, :zip, :phone_number, :user_id

  #Associations
  has_many :relationships
  has_many :users, through: :relationships

  #Model Validations
  validates_presence_of :name, :street_address, :city, :state, :zip
  validates_length_of :zip, :minimum => 5

end
