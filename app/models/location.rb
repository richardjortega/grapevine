class Location < ActiveRecord::Base
  #Before methods and triggers!

  attr_accessible :address_line_2, 
  				  :city, 
  				  :lat, 
  				  :long, 
  				  :name, 
  				  :state, 
  				  :street_address, 
  				  :website, 
  				  :zip, 
  				  :phone_number, 
  				  :user_id

  #Associations
  has_many :relationships
  has_many :users, through: :relationships

  #Model Validations
  validates_presence_of :name, :street_address

  #Geocoding!
  geocoded_by :full_address, :latitude => :lat, :longitude => :long
  after_validation :geocode

  def full_address
    [street_address, address_line_2, city, state, zip].compact.join(', ')
  end
end
