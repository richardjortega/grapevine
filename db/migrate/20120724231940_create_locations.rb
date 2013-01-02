class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name,           :null => false
      t.decimal :lat,           :precision => 15, :scale => 10
      t.decimal :long,          :precision => 15, :scale => 10
      t.string :street_address, :null => false
      t.string :address_line_2
      t.string :city           
      t.string :state
      t.string :zip
      t.string :website

      t.timestamps
    end

    add_index :locations, :name
  end
end
