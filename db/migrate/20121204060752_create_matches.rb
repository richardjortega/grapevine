class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :review_id
      t.integer :source_id
      t.integer :overall_rating
      t.string :source_refer_id

      t.timestamps
    end
  end
end
