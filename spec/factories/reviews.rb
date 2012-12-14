# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    author "MyString"
    author_url "MyString"
    comment "MyString"
    post_date "2012-12-13"
    rating "9.99"
    title "MyString"
    management_response "MyString"
    verified false
    rating_description "MyString"
    url "MyString"
  end
end
