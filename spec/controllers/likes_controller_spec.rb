require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  describe "post#create" do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost) }

    context "ログインしている時" do
      before do
        session[:user_id] = user.id
      end

      it "redirect to micropost_path(micropost) when successs to create a like column" do
        post :create, params: { id: micropost.id }
        expect(response).to redirect_to micropost_path(micropost.id)
      end

      it "いいねに成功したらlikesテーブルのdataが一つ増える" do
        expect { post :create, params: { id: micropost.id } }.to change { user.liking.count }.by(1)
      end
    end

    context "ログインしていない時" do
      it "redirect /login when not logged in" do
        expect(post :create, params: { id: micropost.id }).to redirect_to login_path
      end
    end

    # findで見つからなかった時の例外処理の仕方、勉強不足
  end

  describe "delete#destroy" do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost) }
    let!(:like) { create(:like, user: user, micropost: micropost) }

    context "ログインしている時" do
      before do
        session[:user_id] = user.id
      end

      it "削除に成功したらmicroopost_path(micropost)にredirectする" do
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to micropost_path(micropost)
      end

      it "decreases a likes table's column when successes to delete " do
        expect { delete :destroy, params: { id: like.id } }.to change { user.liking.count }.by(-1)
      end
    end

    context "ログインしていない時" do
      it "redirect when user is not logged in" do
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to login_path
      end
    end
    # findを失敗した時のテスト
  end
end
