FactoryBot.define do
  factory :micropost do
    content "MyText"
    picture ""
    association :user
  end
end
