class CreateVines < ActiveRecord::Migration
  def change
    create_table :vines do |t|
      t.integer :source_id
      t.integer :location_id
      t.string :source_lcation_uri
      t.decimal :overall_rating

      t.timestamps
    end
  end
end
