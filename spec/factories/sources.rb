# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :source do
    name "MyString"
    category "MyString"
    max_rating "9.99"
    accepts_management_response false
    management_response_url "MyString"
    main_url "MyString"
  end
end
