require 'rails_helper'

RSpec.describe Micropost, type: :model do
  #正常な情報を持ったmicropostは保存に成功する
  it "has a valid factory" do
    expect{FactoryBot.create(:micropost)}.to change{Micropost.all.count}.by(1)
  end

  #micropost.content = ""なら保存に失敗する
  it "failds to save micropost with invalid content" do
    user = FactoryBot.build(:micropost, content: "")
    user.valid?
    expect(user.errors[:content]).to include("can't be blank")
  end

  #user_id = " "なら保存に失敗する
  it "failds to save with invalid user_id" do
    user = FactoryBot.build(:micropost, user_id: "")
    user.valid?
    expect(user.errors[:user_id]).to include("can't be blank")
  end
end
