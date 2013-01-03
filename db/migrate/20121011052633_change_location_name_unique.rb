class ChangeLocationNameUnique < ActiveRecord::Migration
  def change
  	remove_index :locations, :column => :name
  	add_index :locations, :name
  end
end
