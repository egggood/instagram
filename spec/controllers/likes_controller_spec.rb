require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  describe "post #create" do
    before do
      @micropost = FactoryBot.create(:micropost)
      @user = User.first
    end
    #いいねに成功したらmicropost_path(micropost)にredirectする
    it "redirect to micropost_path(micropost) when create success" do
      session[:user_id] = @user.id
      post :create, params: {id: @micropost.id}
      expect(response).to redirect_to @micropost
    end
    #いいねに成功したらlikesテーブルのdataが一つ増える
    it "redirect to micropost_path(micropost) when create success" do
      session[:user_id] = @user.id
      expect{post :create, params: {id: @micropost.id}}.to change{@user.liking.count}.by(1)
    end

    #ログインしてないと/loginにredirectする
    it "redirect /login when not logged in" do
      post :create, params: {id: @micropost.id}
      expect(response).to redirect_to '/login'
    end
    #findで見つからなかった時の例外処理の仕方、勉強不足
  end

  describe "delete #destroy" do
    before do
      @micropost = FactoryBot.create(:micropost)
      @like = FactoryBot.create(:like)
      @user = User.first
    end
    #削除に成功したらmicroopost_path(micropost)にredirectする
    it "successes to delete" do
      session[:user_id] = @user.id
      delete :destroy, params: {id: @like.id}
      expect(response).to redirect_to micropost_path(@micropost)
    end
    #削除に成功したらlikesテーブルのdataが一つ減る
    it "decreases a likes table data when successes to delete " do
      session[:user_id] = @user.id
      expect{delete :destroy, params: {id: @like.id}}.to change{@user.liking.count}.by(-1)
    end
    #ログインしてない時は/loginにredirectする
    it "redirect when not logged in" do
      delete :destroy, params: {id: @like.id}
      expect(response).to redirect_to '/login'
    end
    #失敗した時のテスト
  end

end
