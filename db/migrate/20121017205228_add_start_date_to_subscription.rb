class AddStartDateToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :start_date, :date
  end
end
