class ReplyController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = Micropost.find(params[:id])
    @reply = @micropost.reply.new(reply_params)
    if @reply.save
      flash[:success] = "投稿に成功しました。"
      @replies = Reply.all
      redirect_to @micropost
    else
      flash[:danger] = "投稿に失敗しました"
      render 'landingpages/home'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @reply = @micropost.reply.find(params[:id])
    @reply.destroy
    flash[:success] = "返信の削除に成功しました"
    redirect_to @micropost
  end

  private

  def reply_params
    params.require(:reply).permit(:content)
  end
end
