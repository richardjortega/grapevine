class AddMultiLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :multi_location, :boolean
  end
end
