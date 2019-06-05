require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  describe "Post #create" do
    before do
      @user_1 = FactoryBot.create(:user)
      @user_2 = FactoryBot.create(:user)
    end

    it "returns http success" do
      session[:user_id] = @user_1.id
      post :create, params: {followed_id: @user_2.id}
      expect(response).to redirect_to user_path(2)
    end

    #createアクションに成功するとrelationshipsテーブルのデータが一つ増える
    it "increase a data" do
      session[:user_id] = @user_1.id
      expect{post :create, params: {followed_id: @user_2.id}}.to change{Relationship.all.count}.by(1)
    end

    #loginしていないとcreateアクションを実行する前に/loginに飛ぶ
    it "redirect_to /login when not logged in" do
      post :create, params: {followed_id: @user_2.id}
      expect(response).to redirect_to '/login'
    end
  end

  #多対多の関連付けにおけるdestroyのviewとコントローラの関係(form_forの機能)を理解できてない
  describe "Delete #destroy" do
    before do
      @user_1 = FactoryBot.create(:user)
      @user_2 = FactoryBot.create(:user)
    end

    #Relationshipsテーブルの主キーをparams[:id]で選択し、,,どうなってるんだ?
    it "returns http success" do
      session[:user_id] = @user_1.id
      @user_1.follow(@user_2)
      delete :destroy, params: {id: 1}
      expect(response).to redirect_to "#{user_path(2)}"
    end

    #destroyアクションに成功するとrelationshipsテーブルのデータが一つ減る
    it "decrease a data" do
      session[:user_id] = @user_1.id
      @user_1.follow(@user_2)
      expect{delete :destroy, params: {id: 1}}.to change{Relationship.all.count}.by(-1)
    end
  end

end
