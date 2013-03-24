class AddHexColorToSource < ActiveRecord::Migration
  def change
  	add_column :sources, :hex_value, :string
	add_index :sources, :hex_value
  end
end
