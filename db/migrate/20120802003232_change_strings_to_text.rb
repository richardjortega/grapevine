class ChangeStringsToText < ActiveRecord::Migration
  def change
  	change_column	:blasts, :url, :text, :limit => nil
  	change_column	:blasts, :website, :text, :limit => nil
  	change_column	:blasts, :review_description, :text, :limit => nil
  	change_column	:blasts, :marketing_url, :text, :limit => nil
  	change_column	:blasts, :marketing_id, :text, :limit => nil

  end
end
