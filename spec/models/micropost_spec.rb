require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { build(:micropost) }

  it "has a valid factory" do
    expect { micropost.save }.to change { Micropost.all.count }.by(1)
  end

  it "failds to save micropost with invalid content" do
    micropost.content = ""
    micropost.valid?
    expect(micropost.errors[:content]).to include("can't be blank")
  end

  it "failds to save with invalid user_id" do
    micropost.user_id = nil
    micropost.valid?
    expect(micropost.errors[:user_id]).to include("can't be blank")
  end

  it "failds to save micropost whose content is moret than 140 characters" do
    micropost.content = "a" * 141
    micropost.valid?
    expect(micropost.errors[:content]).to include("is too long (maximum is 140 characters)")
  end

  before do
    @user = create(:user)
    create(:micropost, user: @user)
    create(:micropost, user: @user)
  end

  it "deletes all microposts connection a user when the the user is deleted" do
    expect { @user.destroy }.to change { Micropost.all.count }.by(-2)
  end
  # user_idが存在してもそのuserがないと保存できないことを保証するテストを書く
end
