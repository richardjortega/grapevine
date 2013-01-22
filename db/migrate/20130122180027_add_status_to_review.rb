class AddStatusToReview < ActiveRecord::Migration
  def change
  	add_column :reviews, :status, :string
  	add_column :reviews, :status_updated_at, :datetime
  	add_index :reviews, :status
  end
end
