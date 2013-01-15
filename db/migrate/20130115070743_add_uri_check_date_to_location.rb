class AddUriCheckDateToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :uri_check_date, :date
  end
end
