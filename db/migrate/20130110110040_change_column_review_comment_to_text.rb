class ChangeColumnReviewCommentToText < ActiveRecord::Migration
  def up
  	change_column :reviews, :comment, :text, :limit => nil
  end

  def down
  end
end
