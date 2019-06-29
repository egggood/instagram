require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  describe "Post #create" do
    let(:user) { create(:user) }
    let(:micropost_params) { attributes_for(:micropost, user: user) }
    let(:invalid_micropost_params) { attributes_for(:micropost, user: user, content: "") }

    context "ログインしていない時" do
      it "returns http 302" do
        post :create, params: { micropost: { **micropost_params } }
        expect(response).to have_http_status 302
      end

      it "redirect_to login_path " do
        post :create, params: { micropost: { **micropost_params } }
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしている時" do
      before do
        session[:user_id] = user.id
      end

      context "micropostの作成に成功する" do
        it "returns http 302" do
          post :create, params: { micropost: { **micropost_params } }
          expect(response).to have_http_status 302
        end

        it "redirect_to user_path user.id " do
          post :create, params: { micropost: { **micropost_params } }
          expect(response).to redirect_to user_path user.id
        end

        it "create a micropost when succeeds to post a micropost" do
          expect { post :create, params: { micropost: { **micropost_params } } }.to change { Micropost.all.count }.by(1)
        end
      end

      context "micropostの作成に失敗する" do
        it "returns http success" do
          post :create, params: { micropost: { **invalid_micropost_params } }
          expect(response).to have_http_status(:success)
        end

        it "render :new" do
          post :create, params: { micropost: { **invalid_micropost_params } }
          expect(response).to render_template :new
        end

        it "カラムの数が変わらない" do
          expect { post :create, params: { micropost: { **invalid_micropost_params } } }.to change { Micropost.all.count }.by(0)
        end
      end
    end

    context "when user does't login" do
      it "redirect_to login_path" do
        expect(post :create, params: { micropost: { **micropost_params } }).to redirect_to login_path
      end
    end
  end

  describe "Delete#destroy" do
    context "ログインしていない時" do
      let(:user) { create(:user) }
      let(:micropost) { create(:micropost, user: user) }

      it "returns http 302" do
        delete :destroy, params: { id: micropost.id }
        expect(response).to have_http_status 302
      end

      it "redirect_to login_path " do
        delete :destroy, params: { id: micropost.id }
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしている時" do
      let(:user) { create(:user) }
      let!(:micropost) { create(:micropost, user: user) }

      before do
        session[:user_id] = user.id
      end

      context "micropostの削除に成功する" do
        it "redirect_to login_path " do
          delete :destroy, params: { id: micropost.id }
          expect(response).to redirect_to user_path user.id
        end

        it "returns http 302" do
          delete :destroy, params: { id: micropost.id }
          expect(response).to have_http_status 302
        end

        it "decrease a micropost column when succeeds to delete a micropost" do
          expect { delete :destroy, params: { id: micropost.id } }.to change { Micropost.all.count }.by(-1)
        end
      end

      # context "micropostの削除に失敗する" do
        # findで見つからなかった時のerrorを書きたいが、うまくいかない
        # it "rails error" do
        #   expect { delete :destroy, params: { id: 100 } }.to raise_error(ActiveRecord::RecordNotFound)
        # end
      # end
    end
  end

  describe "Get #new" do
    let(:user) { create(:user) }

    context "ログインしていない時" do
      it "return http 302" do
        get :new
        expect(response).to have_http_status 302
      end

      it "redirect_to login_path" do
        get :new
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしいる時" do
      before do
        session[:user_id] = user.id
      end

      it "return http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "render :new" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "Get #show" do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost, user: user) }
    let!(:reply) { create(:reply, micropost: micropost) }

    context "ログインしていない時" do
      it "have http 302" do
        get :show, params: { id: micropost.id }
        expect(response).to have_http_status 302
      end

      it "redirect_to login_path" do
        get :show, params: { id: micropost.id }
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしている時" do
      before do
        session[:user_id] = user.id
        get :show, params: { id: micropost.id }
      end

      context "うまくいくと" do
        it "return http success" do
          expect(response).to have_http_status(:success)
        end

        it "render :show" do
          expect(response).to render_template :show
        end

        it "適切なmicropostが格納されている" do
          expect(assigns(:micropost)).to match(micropost)
        end

        it "適切なrepliesが格納されている" do
          expect(assigns(:replies)).to match(micropost.reply)
        end
      end

      # context "findでerrorが生じる" do
      #   書き方がわからない
      # end
    end
  end
end
