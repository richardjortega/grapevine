class CreateBlasts < ActiveRecord::Migration
  def change
    create_table :blasts do |t|
      t.string :name
      t.text :url
      t.string :rating
      t.string :address
      t.string :total_reviews
      t.string :cuisine
      t.string :price
      t.string :neighborhood
      t.text :website
      t.string :email
      t.string :phone
      t.string :review_rating
      t.text :review_description
      t.string :review_dine_date
      t.text :marketing_url
      t.text :marketing_id

      t.timestamps
    end
  end
end
