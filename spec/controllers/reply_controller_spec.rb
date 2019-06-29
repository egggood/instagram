require 'rails_helper'

RSpec.describe ReplyController, type: :controller do
  describe "Post #create" do
    context "ログインしていない時" do
      let(:micropost) { create(:micropost) }

      it "redirect_to login_path" do
        post :create, params: { id: micropost.id }
        expect(response).to redirect_to login_path
      end

      it "returns http 302" do
        post :create, params: { id: micropost.id }
        expect(response).to have_http_status 302
      end
    end

    context "ログインしている時" do
      let(:user) { create(:user) }
      let(:micropost) { create(:micropost, user: user) }
      let(:vlid_reply_params) { attributes_for(:reply) }
      let(:invlid_reply_params) { attributes_for(:reply, content: "") }

      before do
        session[:user_id] = user.id
      end

      context "作成に成功する" do
        it "redirect_to micropost_path micropost.id" do
          post :create, params: { reply: { **vlid_reply_params }, id: micropost.id }
          expect(response).to redirect_to micropost_path micropost.id
        end

        it "returns http 302" do
          post :create, params: { reply: { **vlid_reply_params }, id: micropost.id }
          expect(response).to have_http_status 302
        end

        it "適切なmicropostが格納されている" do
          post :create, params: { reply: { **vlid_reply_params }, id: micropost.id }
          expect(assigns(:micropost)).to match(micropost)
        end

        it "適切なrepliesが格納されている" do
          post :create, params: { reply: { **vlid_reply_params }, id: micropost.id }
          expect(assigns(:replies)).to match(micropost.reply)
        end

        # カラム数が増加するることを確認するテスト
      end

      context "作成に失敗する" do
        it "render root_path" do
          post :create, params: { reply: { **invlid_reply_params }, id: micropost.id }
          expect(response).to render_template 'landingpages/home'
        end

        it "returns http success" do
          post :create, params: { reply: { **invlid_reply_params }, id: micropost.id }
          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe "Delete #destroy" do
    context "ログインしいない時" do
      let(:micropost) { create(:micropost) }
      let!(:reply) { create(:reply, micropost: micropost) }

      it "redirect_to login_path" do
        delete :destroy, params: { id: reply.id, micropost_id: micropost.id }
        expect(response).to redirect_to login_path
      end

      it "returns https 302" do
        delete :destroy, params: { id: reply.id, micropost_id: micropost.id }
        expect(response).to have_http_status 302
      end
    end

    context "ログインしている時" do
      let(:user) { create(:user) }
      let(:micropost) { create(:micropost, user: user) }
      let!(:reply) { create(:reply, micropost: micropost) }

      before do
        session[:user_id] = user.id
      end

      context "replyの削除に成功する" do
        it "redirect_to micropost_path micropost.id" do
          delete :destroy, params: { id: reply.id, micropost_id: micropost.id }
          expect(response).to redirect_to micropost_path micropost.id
        end

        it "returns https 302" do
          delete :destroy, params: { id: reply.id, micropost_id: micropost.id }
          expect(response).to have_http_status 302
        end

        it "適切なmicropostが格納されている" do
          delete :destroy, params: { id: reply.id, micropost_id: micropost.id }
          expect(assigns(:micropost)).to match micropost
        end

        it "カラムの数がかわる" do
          expect { delete :destroy, params: { id: reply.id, micropost_id: micropost.id } }.to change { micropost.reply.count }.by(-1)
        end
      end

      # context "replyの削除に失敗する" do
      #   erroeが発生する
      # end
    end
  end
end
