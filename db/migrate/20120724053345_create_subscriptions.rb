class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id,             null: false
      t.integer :plan_id,             null: false
      t.boolean :status,              default: false # Tells us if user is actively paid.
      t.string :status_info
      t.integer :current_period_end
      t.integer :current_period_start
      t.integer :trial_end
      t.integer :trial_start
      t.string :stripe_customer_token
      t.string :card_zip
      t.string :last_four
      t.string :card_type
      t.date :next_bill_on
      t.string :card_expiration
      t.date :start_date

      t.timestamps
    end

    add_index :subscriptions, :user_id, unique: true
  end
end
