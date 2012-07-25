class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name,           :null => false
      t.string :lat
      t.string :long
      t.string :street_address, :null => false
      t.string :address_line_2
      t.string :city,           :null => false
      t.string :state,          :null => false
      t.string :zip,            :null => false
      t.string :website

      t.timestamps
    end

    add_index :locations, :name, unique: true
  end
end
