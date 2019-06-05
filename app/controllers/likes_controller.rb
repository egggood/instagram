class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = Micropost.find(params[:id])
    current_user.like(@micropost)
    flash[:success] = "いいねしました！"
    redirect_to micropost_path(@micropost)
  end

  def destroy
    micropost = Like.find(params[:id]).micropost
    current_user.undo_like(micropost)
    redirect_to micropost_path(micropost)
  end
end
