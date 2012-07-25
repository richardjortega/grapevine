class RemoveColumns < ActiveRecord::Migration
  def up
  	remove_column :users, :stripe_id
  	remove_column :users, :last_4_digits
  	remove_column :users, :address_line_1
  	remove_column :users, :address_line_2
  	remove_column :users, :city
  	remove_column :users, :state
  	remove_column :users, :zip_code

  end

  def down
  end
end
