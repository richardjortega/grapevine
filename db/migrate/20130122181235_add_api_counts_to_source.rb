class AddApiCountsToSource < ActiveRecord::Migration
  def change
  	add_column :sources, :api_count_daily, :integer
  	add_column :sources, :api_count_all_time, :integer
  end
end
