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
    #userの作成に成功する
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
      session[:user_id] = @user.id
    end

    it "redirect_to root_url when user is deleted" do
      delete :destroy, params: {id: @user.id}
      expect(response).to redirect_to "/"
    end

    #userがdleteされたらuserの総数は-1される
    it "deleteされたらuser.all.countの数は-1される" do
      delete :destroy, params: {id: @user.id}
      expect(User.all.count).to eq 1
    end
  end

  describe "get #edit" do
    before do
      @user = FactoryBot.create(:user)
    end
    #正常にレスポンス鵜を返すこと
    it "responds succefully" do
      session[:user_id] = @user.id
      get :edit, params: {id: @user.id}
      expect(response).to be_success
    end

    #ログインしてない時はget login_pathに戻る
    it "return login_path when user dose not login" do
      get :edit, params: {id: @user.id}
      expect(response).to redirect_to '/login'
    end

    #ログインしているが自分の情報以外を編集ページに行ったら、root_urlに戻る
    it "return root_url when user edit other user infomation" do
      @other_user = FactoryBot.create(:user)
      session[:user_id] = @user.id
      get :edit, params: {id: @other_user.id}
      expect(response).to redirect_to '/'
      #expect(response).to redirect_to '/'だと3XXを期待したけど200okでしたとエラーに言われた。
      #このテストは一考の余地あり。
    end
  end

  describe "Patch #update" do
    before do
      @param = FactoryBot.attributes_for(:user)
      @user = User.create(**@param)
    end

    #ログインしていて、自分自身を編集する時は更新にに成功する
    it "returns http success when succeeds to update" do
      session[:user_id] = @user.id
      @param[:name] = "new_name"
      patch :update, params: {user: {**@param}, id: @user.id}
      expect(@user.reload.name).to eq "new_name"
    end

    #編集に成功すると/users/:idにtredirectする
    it "redirect_to show.html.view when edit succeeds" do
      session[:user_id] = @user.id
      patch :update, params: {user: {**@param}, id: @user.id}
      expect(response).to redirect_to '/users/1'
    end

    #ログインしてない状態でupdateすると/loginにredirect_toされる
    it "redirect to /login when update user infomatino withou login" do
      @param[:name] = "new_name"
      patch :update, params: {user: {**@param}, id: @user.id}
      expect(response).to redirect_to '/login'
    end

    #ログインしているが違うuserの情報をupdateしようとしたらroot_urlに飛ぶ
    it "redirect_to root_url when update other user infomation" do
      session[:user_id] = @user.id
      other_user_params = FactoryBot.attributes_for(:user)
      other_user = User.create(**other_user_params)
      patch :update, params: {user: {**other_user_params}, id: other_user.id}
      expect(response).to redirect_to '/'
    end

    #ログインして自分の情報を編集しようとするがif文がfalseでusers/editをrenderする
    it "render 'users/edit' when @user.update_attributes failds" do
      session[:user_id] = @user.id
      @param[:name] = ""
      patch :update, params: {user: {**@param}, id: @user.id}
      expect(response).to render_template 'users/edit'
    end

    describe "Get #following" do
      it "returns http success" do
        get :following , params: {id: 1}
        expect(response).to have_http_status(:success)
      end
    end

    describe "#Get #followed" do
      it "returns http success" do
        get :following , params: {id: 1}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
