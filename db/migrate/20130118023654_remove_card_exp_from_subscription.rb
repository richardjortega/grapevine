class RemoveCardExpFromSubscription < ActiveRecord::Migration
  def change
  	remove_column :subscriptions, :card_zip
  	remove_column :subscriptions, :card_expiration
  	add_column :subscriptions, :exp_month, :integer
  	add_column :subscriptions, :exp_year, :integer
  end
end
