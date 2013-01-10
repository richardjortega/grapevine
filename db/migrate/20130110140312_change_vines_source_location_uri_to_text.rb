class ChangeVinesSourceLocationUriToText < ActiveRecord::Migration
  def up
  	change_column :vines, :source_location_uri, :text, :limit => nil
  end

  def down
  end
end
