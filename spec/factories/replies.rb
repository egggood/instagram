FactoryBot.define do
  factory :reply do
    sequence(:micropost_id) {|n| "こんにちは、今日は#{n}日です。"}
    content "MyString"
    association :micropost
  end
end
