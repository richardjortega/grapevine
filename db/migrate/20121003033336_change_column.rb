class ChangeColumn < ActiveRecord::Migration
  def change
  	change_column :locations, :city, :string, :null => true
  	change_column :locations, :state, :string, :null => true
  	change_column :locations, :zip, :string, :null => true
  	change_column :users, :email, :string, :null => false
  end
end
