class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id,             null: false
      t.integer :plan_id,             null: false
      t.boolean :status,              default: false
      t.string :current_period_end
      t.string :current_period_start
      t.string :trial_end
      t.string :trial_start
      t.string :stripe_customer_token
      t.string :card_zip
      t.string :last_four
      t.string :card_type
      t.date :next_bill_on
      t.string :card_expiration

      t.timestamps
    end

    add_index :subscriptions, :user_id, unique: true
  end
end
