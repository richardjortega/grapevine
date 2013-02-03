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
  				  :user_id,
            :uri_check_date

  #Associations
  has_many :relationships
  has_many :users, through: :relationships

  has_many :vines, dependent: :destroy
  has_many :sources, through: :vines

  has_many :reviews, dependent: :destroy

  #Model Validations
  validates_presence_of :street_address, :city, :state, :zip
  validates_presence_of :name, :message => 'Please provide a business name to monitor'
  validates_format_of :zip, :with => /^\d{5}(-\d{4})?$/, :message => "Zip code should be in the form 12345"

  #Geocoding!
  geocoded_by :full_address, :latitude => :lat, :longitude => :long
  after_validation :geocode

  def full_address
    [street_address, address_line_2, city, state, zip].compact.join(', ')
  end


end
