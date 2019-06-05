require 'rails_helper'

RSpec.describe Reply, type: :model do
  #有効なFActoryを持つ
  it "has valid Factory" do
    expect(FactoryBot.build(:reply)).to be_valid
  end

  #contentがblankなら保存に失敗する
  it "failds to save without content" do
    reply = FactoryBot.build(:reply, content: "")
    reply.valid?
    expect(reply.errors[:content]).to include("can't be blank")
  end

  #contentの中身が141文字以上だと保存に失敗する
  it "failds to save with a content containig than 140 character" do
    reply = FactoryBot.build(:reply, content: "a"*141)
    reply.valid?
    expect(reply.errors[:content]).to include("is too long (maximum is 140 characters)")
  end
end
