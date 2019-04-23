require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    user_1 = FactoryBot.create(:user)
    user_2 = FactoryBot.create(:user)
  end
  #有効なファクトロリを持つ
  it "has a valid factory" do
    expect(FactoryBot.create(:relationship)).to be_valid
  end

  #follower_idがnilなら保存に失敗する
  it "is invalid without a follower_id" do
    relationship = FactoryBot.build(:relationship, follower_id: nil)
    relationship.valid?
    expect(relationship.errors[:follower_id]).to include("can't be blank")
  end

  #followed_idがnilなら保存に失敗する
  it "is invalid without a follower_id" do
    relationship = FactoryBot.build(:relationship, followed_id: nil)
    relationship.valid?
    expect(relationship.errors[:followed_id]).to include("can't be blank")
  end
end
