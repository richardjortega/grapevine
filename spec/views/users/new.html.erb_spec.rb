require 'spec_helper'

# describe "users/new" do
#   before(:each) do
#     assign(:user, stub_model(User,
#       :email => "MyString",
#       :name => "MyString",
#       :phone => "MyString",
#       :hashed_password => "MyString",
#       :last_4_digits => "MyString",
#       :stripe_id => "MyString",
#       :subscribed => false
#     ).as_new_record)
#   end

#   it "renders new user form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => users_path, :method => "post" do
#       assert_select "input#user_email", :name => "user[email]"
#       assert_select "input#user_name", :name => "user[name]"
#       assert_select "input#user_phone", :name => "user[phone]"
#       assert_select "input#user_hashed_password", :name => "user[hashed_password]"
#       assert_select "input#user_last_4_digits", :name => "user[last_4_digits]"
#       assert_select "input#user_stripe_id", :name => "user[stripe_id]"
#       assert_select "input#user_subscribed", :name => "user[subscribed]"
#     end
#   end
# end
