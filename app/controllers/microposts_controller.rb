class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :show]

  def new
    @micropost = Micropost.new
  end

  def show
    @micropost = Micropost.find(params[:id])
    @reply = Reply.new
    @replies = @micropost.reply
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿に成功しました"
      redirect_to user_path @current_user.id
    else
      # とりあえずhelpに飛ばす
      render 'landingpages/help'
    end
  end

  def destroy
    # 違うuuserの投稿を削除しようとしたら例外が生じる
    @micropost = @current_user.microposts.find(params[:id])
    @micropost.destroy
    flash[:success] = "削除に成功しました。"
    redirect_to (user_path @current_user.id)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end
end
