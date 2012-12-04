# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :match, :class => 'Matches' do
    review_id 1
    source_id 1
    overall_rating 1
    source_refer_id "MyString"
  end
end
