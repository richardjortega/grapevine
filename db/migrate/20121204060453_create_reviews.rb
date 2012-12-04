class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :location_id
      t.integer :source_id
      t.string :author
      t.string :author_url
      t.string :comment
      t.datetime :post_date
      t.integer :rating
      t.string :rating_description
      t.string :title
      t.boolean :management_response
      t.boolean :verified

      t.timestamps
    end
  end
end
