class AddApprovedToSources < ActiveRecord::Migration
  def change
    add_column :sources, :approved, :boolean, default: false
  end
end
