FactoryBot.define do
  factory :user do
    name "example_user1"
    sequence(:user_name) {|n|  "example_user#{n}"}
    sequence(:email) {|n| "example#{n}@railstutorial.org"}
    #10個以上sequenceが続くとphonenumberの正規表現に引っかかる
    sequence(:phonenumber) {|n| "023-355#{n}-4234"}
    gender "male"
    password "hogehoge"
    password_confirmation "hogehoge"
  end
end
