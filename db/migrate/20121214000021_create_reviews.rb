class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :author
      t.string :author_url
      t.string :comment
      t.date :post_date
      t.decimal :rating
      t.string :title
      t.string :management_response
      t.boolean :verified
      t.string :rating_description
      t.string :url

      t.timestamps
    end
  end
end
