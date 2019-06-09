require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:relationship) { create(:relationship, follower: user_1, followed: user_2) }

  it "has a valid factory" do
    expect(relationship).to be_valid
  end

  it "is invalid without a follower_id" do
    relationship.follower_id = nil
    relationship.valid?
    expect(relationship.errors[:follower_id]).to include("can't be blank")
  end

  it "is invalid without a followed_id" do
    relationship.followed_id = nil
    relationship.valid?
    expect(relationship.errors[:followed_id]).to include("can't be blank")
  end
end
