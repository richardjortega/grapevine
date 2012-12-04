class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :category
      t.integer :max_rating
      t.string :main_url
      t.string :management_response_url

      t.timestamps
    end
  end
end
