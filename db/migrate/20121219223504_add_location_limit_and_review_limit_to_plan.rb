class AddLocationLimitAndReviewLimitToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :location_limit, :integer
    add_column :plans, :review_limit, :integer
  end
end
