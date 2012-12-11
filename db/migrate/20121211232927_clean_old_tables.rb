class CleanOldTables < ActiveRecord::Migration
  def change
  	drop_table :matches
  	drop_table :reviews
  	drop_table :sources
  end
end
