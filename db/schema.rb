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

ActiveRecord::Schema.define(:version => 20130115070743) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.date     "uri_check_date"
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
    t.integer  "location_limit"
    t.integer  "review_limit"
  end

  add_index "plans", ["amount"], :name => "index_plans_on_amount"
  add_index "plans", ["identifier"], :name => "index_plans_on_identifier", :unique => true

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["location_id"], :name => "index_relationships_on_location_id"
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "reviews", :force => true do |t|
    t.integer  "location_id"
    t.integer  "source_id"
    t.string   "author"
    t.string   "author_url"
    t.text     "comment"
    t.date     "post_date"
    t.decimal  "rating"
    t.string   "title"
    t.string   "management_response"
    t.boolean  "verified"
    t.string   "rating_description"
    t.string   "url"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "reviews", ["location_id"], :name => "index_reviews_on_location_id"
  add_index "reviews", ["post_date"], :name => "index_reviews_on_post_date"
  add_index "reviews", ["source_id"], :name => "index_reviews_on_source_id"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.decimal  "max_rating"
    t.boolean  "accepts_management_response"
    t.string   "management_response_url"
    t.string   "main_url"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "sources", ["name"], :name => "index_sources_on_name", :unique => true

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.integer  "plan_id",                                  :null => false
    t.boolean  "status",                :default => false
    t.string   "status_info"
    t.integer  "current_period_end"
    t.integer  "current_period_start"
    t.integer  "trial_end"
    t.integer  "trial_start"
    t.string   "stripe_customer_token"
    t.string   "card_zip"
    t.string   "last_four"
    t.string   "card_type"
    t.date     "next_bill_on"
    t.string   "card_expiration"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "start_date"
  end

  add_index "subscriptions", ["plan_id"], :name => "index_subscriptions_on_plan_id"
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
    t.boolean  "multi_location"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vines", :force => true do |t|
    t.integer  "source_id"
    t.integer  "location_id"
    t.text     "source_location_uri"
    t.decimal  "overall_rating"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "vines", ["location_id"], :name => "index_vines_on_location_id"
  add_index "vines", ["source_id"], :name => "index_vines_on_source_id"
  add_index "vines", ["source_location_uri"], :name => "index_vines_on_source_location_uri"

end
