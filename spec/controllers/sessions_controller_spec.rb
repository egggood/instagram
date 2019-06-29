require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET#new" do
    context "既にログインしている時" do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
        get :new
      end

      it "returns http 302" do
        expect(response).to have_http_status 302
      end

      it "render :new" do
        expect(response).to redirect_to user_path session[:user_id]
      end
    end

    context "ログインしていない時" do
      before { get :new }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "render :new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "Post#create" do
    let(:user_params) { attributes_for(:user) }
    let!(:user) { create(:user, **user_params) }

    context "ログインに成功する" do
      context "ログインして、cookiesを保存する" do
        it "redirect_to user_path user.id" do
          post :create, params: { session: { **user_params, remember_me: 1 } }
          expect(response).to redirect_to user_path user.id
        end

        it "returns http 302" do
          post :create, params: { session: { **user_params, remember_me: 1 } }
          expect(response).to have_http_status 302
        end

        it "session情報を保持する" do
          post :create, params: { session: { **user_params, remember_me: 1 } }
          expect(session[:user_id]).to eq user.id
        end

        it "cookiesがuser情報を保持する" do
          post :create, params: { session: { **user_params, remember_me: 1 } }
          expect(cookies[:user_id]).not_to eq nil
        end
      end

      context "ログインするが、cookiesは保存しない" do
        it "redirect_to user_path user.id" do
          post :create, params: { session: { **user_params, remember_me: 0 } }
          expect(response).to redirect_to user_path user.id
        end

        it "returns http 302" do
          post :create, params: { session: { **user_params, remember_me: 0 } }
          expect(response).to have_http_status 302
        end

        it "session情報を保持する" do
          post :create, params: { session: { **user_params, remember_me: 0 } }
          expect(session[:user_id]).to eq user.id
        end

        it "dose not contains cookies[:user_id] when succeeds to login without params[:session][:remember_me] = '0' " do
          post :create, params: { session: { **user_params, remember_me: 0 } }
          expect(request.cookies[:user_id]).to eq nil
        end
      end
    end

    # context "ログインに失敗する" do
    #   context "params[:session][:user_name]がない時" do
    #
    #   end
    #   context "user.authenticate(params[:session][:password])がnilの時" do
    #
    #   end
    # end
  end

  describe "DELET#destory" do
    let(:user_params) { attributes_for(:user) }
    let!(:user) { create(:user, **user_params) }

    before do
      post :create, params: { session: { **user_params, remember_me: 1 } }
    end

    it "redirect_to root_path" do
      delete :destroy
      expect(response).to redirect_to root_path
    end

    it "returns http 302" do
      delete :destroy
      expect(response).to have_http_status 302
    end

    it "session情報を保持しない" do
      delete :destroy
      expect(session[:user_id]).to eq nil
    end

    it "cooky情報を保持しない" do
      delete :destroy
      expect(response.cookies[:user_id]).to eq nil
    end
  end
end
