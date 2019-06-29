require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    before { get :new }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "rendet :new" do
      expect(response).to render_template :new
    end
  end

  describe "#index" do
    let!(:first_user) { create(:user) }
    let!(:second_user) { create(:user) }

    before { get :index }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "rendet :new" do
      expect(response).to render_template :index
    end

    it "適切なuserを保持する" do
      expect(assigns(:users)).to match(User.all)
    end
  end

  describe "#show" do
    let(:user) { create(:user) }
    let!(:micropost) { create(:micropost, user: user) }

    before do
      session[:user_id] = user.id
      get :show, params: { id: user.id }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render :show" do
      expect(response).to render_template :show
    end

    it "has appropriate user" do
      expect(assigns(:user)).to eq user
    end

    it "has appropriate microposts" do
      expect(assigns(:microposts)).to match_array([micropost])
    end
  end

  describe "#create" do
    context "userの作成に成功する" do
      let(:user_params) { attributes_for(:user) }

      it "redirect_to user_path user.id" do
        post :create, params: { user: user_params }
        # user_path(user.id)としたいがidはDBに保存されてつくのでお手上げ
        expect(response).to redirect_to "/users/1"
      end

      it "has http 302" do
        post :create, params: { user: user_params }
        expect(response).to have_http_status 302
      end

      it "適切なuserを保持する" do
        post :create, params: { user: user_params }
        expect(assigns(:user)).to match(User.find_by(name: user_params[:name]))
      end
    end

    context "userの作成に失敗する" do
      let(:invalid_user_params) { attributes_for(:user, user_name: "") }

      it "returns http success" do
        post :create, params: { user: invalid_user_params }
        expect(response).to have_http_status(:success)
      end

      it "render 'users/new'" do
        post :create, params: { user: invalid_user_params }
        expect(response).to render_template 'users/new'
      end

      # カラム数が増加するることを確認するテスト
    end
  end

  describe "DELETE#destory" do
    context "ログインしている時" do
      let(:user) { create(:user) }
      let!(:other_user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      context "自分を削除する" do
        context "成功する" do
          it "redirect_to root_path" do
            delete :destroy, params: { id: user.id }
            expect(response).to redirect_to root_path
          end

          it "has http 302" do
            delete :destroy, params: { id: user.id }
            expect(response).to have_http_status 302
          end

          it "deleteされたらuser.all.countの数は-1される" do
            expect { delete :destroy, params: { id: user.id } }.to change { User.all.count }.by(-1)
          end

          it "session情報を持たない" do
            delete :destroy, params: { id: user.id }
            expect(session[:user_id]).to eq nil
          end

          it "cooky情報を持たない" do
            delete :destroy, params: { id: user.id }
            expect(cookies[:user_id]).to eq nil
          end
        end

        # rails error
        # context "失敗する" do
        # end
      end

      context "他人を削除しようとする" do
        it "redirect_to root_path" do
          delete :destroy, params: { id: other_user.id }
          expect(response).to redirect_to root_path
        end

        it "has http 302" do
          delete :destroy, params: { id: other_user.id }
          expect(response).to have_http_status 302
        end

        it "deleteされたらuser.all.countの数は-0される" do
          expect { delete :destroy, params: { id: other_user.id } }.to change { User.all.count }.by(0)
        end
      end
    end

    context "ログインしていない時" do
      let!(:user) { create(:user) }

      it "redirect_to login_path" do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to login_path
      end

      it "has http 302" do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status 302
      end

      it "deleteされたらuser.all.countの数は変わらない" do
        expect { delete :destroy, params: { id: user.id } }.to change { User.all.count }.by(0)
      end
    end
  end

  describe "get #edit" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context "ログインしている時" do
      before do
        session[:user_id] = user.id
      end

      context "自分の編集画面にアクセスする" do
        it "returns http success" do
          get :edit, params: { id: user.id }
          expect(response).to be_success
        end

        it "render #edit" do
          get :edit, params: { id: user.id }
          expect(response).to render_template :edit
        end

        it "適切なuser情報を取得する" do
          get :edit, params: { id: user.id }
          expect(assigns(:user)).to match(user)
        end
      end

      context "他人の編集画面にアクセスしようとする" do
        it "redirect_to root_path" do
          get :edit, params: { id: other_user.id }
          expect(response).to redirect_to root_path
        end

        it "returns http 302" do
          get :edit, params: { id: other_user.id }
          expect(response).to have_http_status 302
        end
      end
    end

    context "ログインしていない時" do
      it "redirect_to login_path" do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to login_path
      end

      it "returns http 302" do
        get :edit, params: { id: user.id }
        expect(response).to have_http_status 302
      end
    end
  end

  describe "Patch #update" do
    let(:old_user_params) { attributes_for(:user, name: "old_name") }
    let(:new_user_params) { attributes_for(:user, name: "new_name") }
    let(:invalid_user_params) { attributes_for(:user, name: nil) }
    let(:user) { create(:user, **old_user_params) }
    let(:other_user) { create(:user) }

    context "ログインしている時" do
      before do
        session[:user_id] = user.id
      end

      context "更新に成功する" do
        it "redirect_to user_path user.id" do
          patch :update, params: { user: new_user_params, id: user.id }
          expect(response).to redirect_to user_path user.id
        end

        it "returns http 302" do
          patch :update, params: { user: new_user_params, id: user.id }
          expect(response).to have_http_status 302
        end

        it "情報が更新される" do
          patch :update, params: { user: new_user_params, id: user.id }
          expect(new_user_params[:name]).to eq(user.reload.name)
        end
      end

      context "更新に失敗する" do
        context "自分の情報を更新しようとした時" do
          it "render_template :edit" do
            patch :update, params: { user: invalid_user_params, id: user.id }
            expect(response).to render_template :edit
          end

          it "returns http 302" do
            patch :update, params: { user: invalid_user_params, id: other_user.id }
            expect(response).to have_http_status 302
          end
        end

        context "他人の情報を更新しようとした時" do
          it "redirect_to root_path" do
            patch :update, params: { user: new_user_params, id: other_user.id }
            expect(response).to redirect_to root_path
          end

          it "returns http 302" do
            patch :update, params: { user: new_user_params, id: user.id }
            expect(response).to have_http_status 302
          end
        end
      end
    end

    context "ログイしていない時" do
      it "redirect_to login_path" do
        patch :update, params: { id: user.id }
        expect(response).to redirect_to login_path
      end

      it "returns http 302" do
        patch :update, params: { id: user.id }
        expect(response).to have_http_status 302
      end
    end
  end

  describe "Get#following" do
    let(:user) { create(:user) }
    let(:following) { create(:user) }

    context "ログインしている時" do
      before do
        session[:user_id] = user.id
        user.following << [following]
      end

      it "has http success" do
        get :following, params: { id: user.id }
        expect(response).to have_http_status(:success)
      end

      it "render 'users/show_follow'" do
        get :following, params: { id: user.id }
        expect(response).to render_template 'users/show_follow'
      end

      it "適切なtitleを取得する" do
        get :following, params: { id: user.id }
        expect(assigns(:title)).to match "Following"
      end

      it "適切なuserを取得する" do
        get :following, params: { id: user.id }
        expect(assigns(:user)).to match user
      end

      it "適切なfollowingを取得する" do
        get :following, params: { id: user.id }
        expect(assigns(:users)).to match_array(user.following)
      end
    end

    context "ログイしていない時" do
      it "redirect_to login_path" do
        get :following, params: { id: user.id }
        expect(response).to redirect_to login_path
      end

      it "has http 302" do
        get :following, params: { id: user.id }
        expect(response).to have_http_status 302
      end
    end
  end

  describe "Get#followed" do
    let(:user) { create(:user) }
    let(:follower) { create(:user) }

    context "ログインしている時" do
      before do
        session[:user_id] = user.id
        user.followers << [follower]
      end

      it "has http success" do
        get :followers, params: { id: user.id }
        expect(response).to have_http_status(:success)
      end

      it "render 'users/show_follow'" do
        get :followers, params: { id: user.id }
        expect(response).to render_template 'users/show_follow'
      end

      it "適切なtitleを取得する" do
        get :followers, params: { id: user.id }
        expect(assigns(:title)).to match "Followers"
      end

      it "適切なuserを取得する" do
        get :followers, params: { id: user.id }
        expect(assigns(:user)).to match user
      end

      it "適切なfollowingを取得する" do
        get :followers, params: { id: user.id }
        expect(assigns(:users)).to match_array(user.followers)
      end
    end

    context "ログイしていない時" do
      it "redirect_to login_path" do
        get :followers, params: { id: user.id }
        expect(response).to redirect_to login_path
      end

      it "has http 302" do
        get :followers, params: { id: user.id }
        expect(response).to have_http_status 302
      end
    end
  end
end
