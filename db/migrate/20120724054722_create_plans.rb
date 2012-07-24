class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :amount, null: false
      t.string :currency, null: false
      t.string :interval, null: false

      t.timestamps
    end

    add_index :plans, :slug, unique: true
    add_index :plans, :amount
  end
end
