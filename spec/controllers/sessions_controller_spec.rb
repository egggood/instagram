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

      it "successfully login " do
        post :create, params: @param
        expect(response).to redirect_to "/users/1"
      end
    end

    context "as invalid user that infomation has not been recorded in database" do
      before do
        @param = {session: FactoryBot.attributes_for(:user)}
        user = User.new(@param[:session])
      end

      it "unsuccessfully login " do
        @param[:session][:user_name] = " "
        post :create, params: @param
        expect(response).to render_template "sessions/new"
      end
    end
  end

  describe "DELET #destory" do
    before do
      @user = FactoryBot.create(:user)
      session[:user_id] = @user.id
    end
    #ログアウトに成功する
    it "succeeds to logout" do
      delete :destroy, params: {id: session[:user_id]}
      expect(response).to redirect_to '/'
    end

    # #ちゃんとログアウトに失敗する
    # #例外(find)波動処理すればいいのか不明
    # it "failed to logout" do
    #
    # end
  end
end
