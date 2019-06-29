FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:name) { |n| "example_user#{n}" }
    sequence(:user_name) { |n| "user_id#{n}" }
    sequence(:email) { |n| "example#{n}@railstutorial.org" }
    # 10個以上sequenceが続くとphonenumberの正規表現に引っかかる
    sequence(:phonenumber) { |n| "023-355#{n}-4234" }
    gender "male"
    self_introduction "こんにちは"
    password "hogehoge"
    password_confirmation "hogehoge"
  end
end
