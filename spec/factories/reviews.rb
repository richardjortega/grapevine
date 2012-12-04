# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    location_id 1
    source_id 1
    author "MyString"
    author_url "MyString"
    comment "MyString"
    post_date "2012-12-04 00:04:54"
    rating 1
    rating_description "MyString"
    title "MyString"
    management_response false
    verified false
  end
end
