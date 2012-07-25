class AddColumns < ActiveRecord::Migration
  def up
  	add_column :users, :phone_number, :string
  end

  def down
  end
end
