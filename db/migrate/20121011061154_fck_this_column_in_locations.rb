class FckThisColumnInLocations < ActiveRecord::Migration
  def self.up
  	rename_column :locations, :lat, :lat_string
  	rename_column :locations, :long, :long_string
  	add_column :locations, :lat, :decimal, :precision => 15, :scale => 10
  	add_column :locations, :long, :decimal, :precision => 15, :scale => 10

  	Location.reset_column_information
  	Location.find_each { |l| l.update_attribute(:lat, l.lat_string) }
  	remove_column :locations, :lat_string
  	Location.find_each { |l| l.update_attribute(:long, l.long_string) }
  	remove_column :locations, :long_string

  end
end
