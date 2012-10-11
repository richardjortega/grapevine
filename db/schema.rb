# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121011061154) do

  create_table "blasts", :force => true do |t|
    t.string   "name"
    t.text     "url"
    t.string   "rating"
    t.string   "address"
    t.string   "total_reviews"
    t.string   "cuisine"
    t.string   "price"
    t.string   "neighborhood"
    t.text     "website"
    t.string   "email"
    t.string   "phone"
    t.string   "review_rating"
    t.text     "review_description"
    t.string   "review_dine_date"
    t.text     "marketing_url"
    t.text     "marketing_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name",                                           :null => false
    t.string   "street_address",                                 :null => false
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "website"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.decimal  "lat",            :precision => 15, :scale => 10
    t.decimal  "long",           :precision => 15, :scale => 10
  end

  add_index "locations", ["name"], :name => "index_locations_on_name"

  create_table "plans", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "identifier",        :null => false
    t.integer  "amount",            :null => false
    t.string   "currency",          :null => false
    t.string   "interval",          :null => false
    t.integer  "trial_period_days"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "plans", ["amount"], :name => "index_plans_on_amount"
  add_index "plans", ["identifier"], :name => "index_plans_on_identifier", :unique => true

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.integer  "plan_id",                                  :null => false
    t.boolean  "status",                :default => false
    t.string   "status_info"
    t.string   "current_period_end"
    t.string   "current_period_start"
    t.string   "trial_end"
    t.string   "trial_start"
    t.string   "stripe_customer_token"
    t.string   "card_zip"
    t.string   "last_four"
    t.string   "card_type"
    t.date     "next_bill_on"
    t.string   "card_expiration"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
