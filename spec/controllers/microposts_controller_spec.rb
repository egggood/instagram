require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  describe "Post #create" do
    let(:param) { attributes_for(:micropost) }

    before do
      create(:user)
      session[:user_id] = 1
    end

    context "ログインしている時" do
      it "create a micropost when succeeds to post a micropost" do
        expect { post :create, params: { micropost: { **param } } }.to change { Micropost.all.count }.by(1)
      end

      it "render 'landingpages/help' when @micropost.save => false" do
        param[:content] = ""
        expect { post :create, params: { micropost: { **param } } }.to change { Micropost.all.count }.by(0)
      end
    end

    # context "when user does't login" do
    #
    # end
  end

  describe "Delete #destroy" do
    let(:micropost) { create(:micropost) }

    it "decrease a micropost when succeeds to delete amicropost suucceeds" do
      session[:user_id] = micropost.user_id
      expect { delete :destroy, params: { id: micropost.id } }.to change { Micropost.all.count }.by(-1)
    end

    it "redirect_to /login when not log in" do
      delete :destroy, params: { id: micropost.id }
      expect(response).to redirect_to '/login'
    end

    it "rederect_to root_path when attempts to delete ohter user micrpost with login" do
      pending '例外発生した時のテストの書き方が分からない'
      micropost_1 = create(:micropost)
      micropost_2 = create(:micropost)
      session[:user_id] = micropost_1.user_id
      delete :destroy, params: { id: micropost_2.id }
      expect(@micropost).to eq nil
    end
  end

  describe "Get #new" do
    before do
      get :new
    end

    it "return http success" do
      expect(response).to have_http_status(:success)
    end

    it "render :new" do
      expect(response).to render_template :new
    end
  end

  describe "Get #show" do
    let(:user) { create(:user) }

    before do
      create(:micropost, user: user)
      session[:user_id] = user.id
      get :show, params: { id: user.id }
    end

    it "return http success" do
      expect(response).to have_http_status(:success)
    end

    it "render :show" do
      expect(response).to render_template :show
    end
  end
  # pictureに関するテストはどう書けばいいか分からなかった。
end
