class Location < ActiveRecord::Base
  attr_accessible :address_line_2, :city, :lat, :long, :name, :state, :street_address, :website, :zip
end
