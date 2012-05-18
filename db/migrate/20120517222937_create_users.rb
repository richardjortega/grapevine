class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.string :hashed_password
      t.string :last_4_digits
      
      t.string :stripe_id
      t.boolean :subscribed, :default => false

      t.timestamps
    end

      add_index :users, :email, :unique => true
  end
end
