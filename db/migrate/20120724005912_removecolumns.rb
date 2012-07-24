class Removecolumns < ActiveRecord::Migration
  def up
  	remove_column :users, :phone_number
  end

  def down
  end
end
