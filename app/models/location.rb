class Location < ActiveRecord::Base
  attr_accessible :address_line_2, :city, :lat, :long, :name, :state, :street_address, :website, :zip, :phone_number

  #Associations
  has_many :users, :through => :relationships

  #Model Validations
  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip


end
