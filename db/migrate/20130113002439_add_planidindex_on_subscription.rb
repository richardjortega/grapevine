class AddPlanidindexOnSubscription < ActiveRecord::Migration
  def change
  	add_index :subscriptions, :plan_id
  end
end
