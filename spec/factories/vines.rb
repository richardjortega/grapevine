# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vine do
    source_id 1
    location_id 1
    source_lcation_uri "MyString"
    overall_rating "9.99"
  end
end
