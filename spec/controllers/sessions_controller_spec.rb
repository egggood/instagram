require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "Post #create" do

    context "as valid user that infomation has been recorded in database" do
      before do
        @param = {session: FactoryBot.attributes_for(:user)}
        user = User.create(@param[:session])
      end
      context "login with a cookies" do

        before do
          @param[:session][:remember_me] = 1
        end

        it "successfully login " do
          post :create, params: @param
          expect(response).to redirect_to "/users/1"
        end

        it "contains cookies[:user_id] when succeeds to login with params[:session][:remember_me] = '1' " do
          post :create, params: @param
          expect(cookies[:user_id]).not_to eq nil
        end
      end

      context "login without a cookies" do
        #上のcontextと重複したテストそしてしまっている
        it "successfully login " do
          post :create, params: @param
          expect(response).to redirect_to "/users/1"
        end

        it "dose not contains cookies[:user_id] when succeeds to login without params[:session][:remember_me] = '0' " do
          post :create, params: @param
          expect(cookies[:user_id]).to eq nil
        end
        #session[:user_id]がnil出ないテストも書いた方がいいのかな?スペックテストでまとめた方がコードの量も可読性も上がりそう。
      end
    end


    context "as invalid user that infomation has not been recorded in database" do
      before do
        @param = {session: FactoryBot.attributes_for(:user)}
        user = User.create(@param[:session])
        @param[:session][:user_name] = " "
      end

      it "unsuccessfully login " do
        post :create, params: @param
        expect(response).to render_template "sessions/new"
      end

      it "dose not contain cookies[:user_id] when failded to login" do
        post :create, params: @param
        expect(cookies[:user_id]).to eq nil
      end
    end
  end

  describe "DELET #destory" do
    before do
      @param = {session: FactoryBot.attributes_for(:user)}
      user = User.create(@param[:session])
      @param[:session][:remember_me] = 1
    end

    #ログアウトに成功するしたらroot_urlにリダイレクトする
    it "succeeds to logout" do
      delete :destroy, params: {**@param, id: 1}
      expect(response).to redirect_to '/'
    end

    #ログアウトに成功したらsession[:user_id]はnilになってる
    it "dose not contain session[:user_id] when succeeds to logout" do
      delete :destroy, params: {**@param, id: 1}
      expect(session[:user_id]).to eq nil
    end

    #ログアウトに成功したらcookies[:user_id]はnilになってる
    it "dose not contain session[:user_id] when succeeds to logout" do
      delete :destroy, params: {**@param, id: 1}
      expect(cookies[:user_id]).to eq nil
    end

    # #ちゃんとログアウトに失敗する
    # #例外(find)波動処理すればいいのか不明
    # it "failed to logout" do
    #
    # end
  end
end
