require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user: user) }
  let(:like) { build(:like, user: user, micropost: micropost) }

  it "has a valid Factory" do
    expect(like).to be_valid
  end

  context "likeに必要な情報がかけているため保存に失敗する" do
    it "failds to save without a valid user_id" do
      like.user_id = ""
      like.valid?
      expect(like.errors[:user_id]).to include("can't be blank")
    end

    it "failds to save without a valid micropost_id" do
      like.micropost_id = ""
      like.valid?
      expect(like.errors[:micropost_id]).to include("can't be blank")
    end

    # 同じ組み合わせは保存できない,DBでの設定をどうテストすればいいのか分からない
    it "failds to save with user_id and macripost_id that were already saved" do
      other_like = like.dup
      like.save
      pending "activerecordで重複を許さない時のmatcherをどう書くかわからない"
      expect(other_like.save).to raise_error(ActiveRecord::RecordNotUnique)
    end
    #
    # 関連するmicropostが存在しない時は保存できない
    # (icropost_id:120ならmicropostsテーブルでmicropost.id:120が存在するべきだがしていない)
    # it "failds to save when user is not exit" do
    #   FactoryBot.create(:micropost)
    #   like = FactoryBot.build(:like)
    #   User.first.destroy
    #   like.valid?
    #   expect(like.errors[:user]).to include("must exist")
    # end
    # # 関連するuserが存在しない時は保存できない
    # # (user_id:120ならusersテーブルでuser.id:120が存在するべきだがしていない)
    # it "failds to save when micropost is not exit" do
    #   FactoryBot.create(:micropost)
    #   like = FactoryBot.build(:like)
    #   Micropost.first.destroy
    #   like.valid?
    #   expect(like.errors[:micropost]).to include("must exist")
    # end
  end
end
