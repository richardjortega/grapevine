class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :identifier, null: false
      t.integer :amount, null: false
      t.string :currency, null: false
      t.string :interval, null: false
      t.integer :trial_period_days
      t.integer :location_limit
      t.integer :review_limit

      t.timestamps
    end

    add_index :plans, :identifier, unique: true
    add_index :plans, :amount
  end
end
