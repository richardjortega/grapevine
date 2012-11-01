class ChangeStringsToNumbersSubscription < ActiveRecord::Migration
  def change
  	change_column	:subscriptions, :current_period_end, :integer
  	change_column	:subscriptions, :current_period_start, :integer
  	change_column	:subscriptions, :trial_end, :integer
  	change_column	:subscriptions, :trial_start, :integer
  	change_column	:subscriptions, :start_date, :integer
  end
end
