class CreateVines < ActiveRecord::Migration
  def change
    create_table :vines do |t|
      t.integer :source_id
      t.integer :location_id
      t.integer :review_id
      t.string :source_location_uri
      t.decimal :overall_rating

      t.timestamps
    end
  end
end
