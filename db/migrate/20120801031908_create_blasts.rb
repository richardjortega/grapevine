class CreateBlasts < ActiveRecord::Migration
  def change
    create_table :blasts do |t|
      t.string :name
      t.string :url
      t.string :rating
      t.string :address
      t.string :total_reviews
      t.string :cuisine
      t.string :price
      t.string :neighborhood
      t.string :website
      t.string :email
      t.string :phone
      t.string :review_rating
      t.string :review_description
      t.string :review_dine_date
      t.string :marketing_url
      t.integer :marketing_id

      t.timestamps
    end
  end
end
