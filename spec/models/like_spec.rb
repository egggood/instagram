require 'rails_helper'

RSpec.describe Like, type: :model do
  #有効なFactoryを持つ
  it "has a valid Factory" do
    #userとmicropostを作っている、belongs_toのためこれらが存在しないと保存できない
    FactoryBot.create(:micropost)
    expect(FactoryBot.build(:like)).to be_valid
  end

  #user_idがnilなら保存されない
  it "failds to save without a valid user_id" do
    FactoryBot.create(:micropost)
    like = FactoryBot.build(:like, user_id: "")
    like.valid?
    expect(like.errors[:user_id]).to include("can't be blank")
  end
  #micropost_idがnilなら保存されない
  it "failds to save without a valid micropost_id" do
    FactoryBot.create(:micropost)
    like = FactoryBot.build(:like, micropost_id: "")
    like.valid?
    expect(like.errors[:micropost_id]).to include("can't be blank")
  end

  # #同じ組み合わせは保存できない,DBでの設定をどうテストすればいいのか分からない
  # it "failds to save a same data that was already saved" do
  #   FactoryBot.create(:micropost)
  #   like_1 = FactoryBot.create(:like)
  #   like_2 = Like.new(user_id: 1, micropost_id: 1)
  #   expect(like_2.)
  # end

  #関連するmicropostが存在しない時は保存できない
  #(icropost_id:120ならmicropostsテーブルでmicropost.id:120が存在するべきだがしていない)
  it "failds to save when user is not exit" do
    FactoryBot.create(:micropost)
    like = FactoryBot.build(:like)
    User.first.destroy
    like.valid?
    expect(like.errors[:user]).to include("must exist")
  end
  #関連するuserが存在しない時は保存できない
  #(user_id:120ならusersテーブルでuser.id:120が存在するべきだがしていない)
  it "failds to save when micropost is not exit" do
    FactoryBot.create(:micropost)
    like = FactoryBot.build(:like)
    Micropost.first.destroy
    like.valid?
    expect(like.errors[:micropost]).to include("must exist")
  end
end
