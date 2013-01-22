class AddCreatedAtIndexToLocation < ActiveRecord::Migration
  def change
  	add_index :locations, :created_at
  end
end
