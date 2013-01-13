class AddIndicesToRelationships < ActiveRecord::Migration
  def change
  	add_index :relationships, :user_id
  	add_index :relationships, :location_id
  end
end
