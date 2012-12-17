class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :category
      t.decimal :max_rating
      t.boolean :accepts_management_response
      t.string :management_response_url
      t.string :main_url

      t.timestamps
    end
  end
end
