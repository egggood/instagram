require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  describe "Post #create" do
    #micropostの投稿に成功するとmicropostカラムが一つ増える
    it "create a micropost when post a micropost succeeds" do
      FactoryBot.create(:user)
      session[:user_id] = 1
      param = FactoryBot.attributes_for(:micropost)
      expect{post :create, params: {micropost: {**param}}}.to change{Micropost.all.count}.by(1)
    end

    #micropostの投稿に失敗したら/helpに飛ぶ
    it "render 'landingpages/help' when @micropost.save => false" do
      FactoryBot.create(:user)
      session[:user_id] = 1
      param = FactoryBot.attributes_for(:micropost)
      param[:content] = ""
      expect{post :create, params: {micropost: {**param}}}.to change{Micropost.all.count}.by(0)
    end
  end

  describe "Delete #destroy" do
    #micropostの削除に成功するとmicropostカラムが一つ減る
    it "decrease a micropost when delete amicropost suucceeds" do
      micropost  = FactoryBot.create(:micropost)
      session[:user_id] = micropost.user_id
      expect{delete :destroy, params: {id: micropost.id}}.to change{Micropost.all.count}.by(-1)
    end

    #loginしていいないyouserが削除しようとする
    it "redirect_to /login when not log in" do
      micropost  = FactoryBot.create(:micropost)
      delete :destroy, params: {id: micropost.id}
      expect(response).to redirect_to '/login'
    end
    #ログインしているが、自分の投稿以外を削除しようとすると削除に失敗し、flash[danger]に値が入る
    it "rederect_to root_path when attempts to delete ohter user micrpost with login" do
      pending '例外発生した時のテストの書き方が分からない'
      micropost_1 = FactoryBot.create(:micropost)
      micropost_2 = FactoryBot.create(:micropost)
      session[:user_id] = micropost_1.user_id
      delete :destroy, params: {id: micropost_2.id}
      expect(@micropost).to eq nil
    end
  end

  describe "Get #new" do
    #micrposts/newへのアクセスに成功する
    it "return http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "Get #show" do
    before do
      @user = FactoryBot.create(:user)
      FactoryBot.create(:micropost)
    end
    #アクセスに成功するとresponseに200が含まれる
    it "return http success" do
      session[:user_id] = @user.id
      get :show, params: {id: @user.id}
      expect(response).to have_http_status(:success)
    end
  end

  #pictureに関するテストはどう書けばいいか分からなかった。
end
