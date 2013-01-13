class AddIndexesToReviews < ActiveRecord::Migration
  def change
  	add_index :reviews, :location_id
  	add_index :reviews, :source_id
  	add_index :reviews, :post_date
  end
end
