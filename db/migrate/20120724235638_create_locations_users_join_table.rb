class CreateLocationsUsersJoinTable < ActiveRecord::Migration
  def change
  	create_table :locations_users, :id => false do |t|
  		t.integer :location_id
  		t.integer :user_id
  end
end
