class AddIndexesToVines < ActiveRecord::Migration
  def change
  	add_index :vines, :source_id
  	add_index :vines, :location_id
  	add_index :vines, :source_location_uri
  end
end
