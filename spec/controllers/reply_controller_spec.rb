require 'rails_helper'

RSpec.describe ReplyController, type: :controller do
  describe "Post #create" do
    before do
      FactoryBot.create(:reply)
      #上のコマンドで生成されたmicropostを取り出したい
      @micropost = Micropost.first
      @user = User.first
    end
    #投稿に成功したらmicropost/show/:idに戻る
     it "return http success" do
       session[:user_id] = @user.id
       post :create, params: {reply: {micropost_id: @micropost.id, content: "こんにちは"}, id: @micropost.id}
       expect(response).to redirect_to @micropost
     end

     #投稿に成功したらrepliesテーブルの行が一つ増える

     #投稿に失敗したらroot_pathい戻る
     it "render root_path with a invalid content" do
       session[:user_id] = @user.id
       post :create, params: {reply: {micropost_id: @micropost.id, content: "a"*141}, id: @micropost.id}
       expect(response).to render_template "landingpages/home"
     end

     #ログインしてないと/loginにとぶ
     it "redirect_to login_path when not logged in" do
       post :create, params: {reply: {micropost_id: @micropost.id, content: "こんにちは"}, id: @micropost.id}
       expect(response).to redirect_to "#{login_path}"
     end
  end

  describe "Delete #destroy" do
    before do
      @reply = FactoryBot.create(:reply)
      #上のコマンドで生成されたmicropostを取り出したい
      @micropost = Micropost.first
      @user = User.first
    end

    #削除に成功したらmicropost_pathにredirect_toする
    it "redirect_to micropost_paht when successes to delete a reply" do
      session[:user_id] = @user.id
      delete :destroy, params: {id: @reply.id, micropost_id: @micropost.id}
      expect(response).to redirect_to micropost_path(@micropost)
    end

    #削除に成功したらrepliesテーブルの行が一つ減る。
    it "redirect_to micropost_paht when successes to delete a reply" do
      session[:user_id] = @user.id
      expect{delete :destroy, params: {id: @reply.id, micropost_id: @micropost.id}}.to change{@micropost.reply.count}.by(-1)
    end

    #削除に成功したらmicropost_pathにredirect_toする
    it "redirect_to micropost_paht when successes to delete a reply" do
      delete :destroy, params: {id: @reply.id, micropost_id: @micropost.id}
      expect(response).to redirect_to login_path
    end
  end

end
