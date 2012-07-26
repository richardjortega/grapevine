class Location < ActiveRecord::Base
  attr_accessible :address_line_2, :city, :lat, :long, :name, :state, :street_address, :website, :zip

  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :address_line_2
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip


end
