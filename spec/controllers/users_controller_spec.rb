require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end


  describe "#show" do

    before do
      @user = FactoryBot.create(:user)
    end

    it "returns http success" do
      get :show, params: {id: @user.id}
      expect(response).to have_http_status(:success)
    end
  end


  #ストロングパラメータを使ったコントローラをRSpecでテストする方法が分からない
  describe "#create" do
    before do
      @user = FactoryBot.build(:user)
    end

    #ローカル変数paramaを使うとuser_paramsを突破できるがなぜだかは不明、学習が進んだらhtml or httpの記述ととparamsの関係を調べてみる。
    #redirect_to "/users/#{@user.id}"みたいにしたい..
    it "redirect_to /users/n\#{@user.id} when @user.save => true" do
      param = {user:FactoryBot.attributes_for(:user)}
      post :create, params: param
      expect(response).to redirect_to "/users/1"
    end

    it "render 'users#new' when @user.save => false" do
      param = {user:FactoryBot.attributes_for(:user, user_name: "")}
      post :create, params: param
      expect(response).to render_template 'users/new'
    end
  end

  #userカラム数の変動とcontroller#deleteでdef delete endを通ってredirect_toされる
  #テストは何を基準としてフューチャーテストと分離すべきか。
  #今回はアクションの中身は無視してactionを呼び適切なviewを引き出すことに絞るうことにした、
  describe "DELETE #destory" do
    before do
      @user = FactoryBot.create(:user)
      @othre_user1 = FactoryBot.create(:user)
      other_user2 = FactoryBot.create(:user)
    end

    it "redirect_to root_url when user is deleted" do
      delete :destroy, params: {id: @user.id}
      expect(response).to redirect_to "/"
    end

    #userがdleteされたらuserの総数は-1される
    it "deleteされたらuser.all.countの数は-1される" do
      pending
      delete :destroy, params: {id: @other_user1.id}
      expect(User.all.count).to eq 2
    end

    #userがdleteされたらuserの総数は-1される
    it "deleteされたらuser.all.countの数は-1される" do
      delete :destroy, params: {id: @user.id}
      expect(User.all.count).to eq 2
    end
  end

end
