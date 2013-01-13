class AddIndexesToSources < ActiveRecord::Migration
  def change
  	add_index :sources, :name, :unique => true
  end
end
