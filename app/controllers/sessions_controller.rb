class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(user_name: params[:session][:user_name])
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "ログインに成功しました^ ^"
      log_in user
      redirect_to user
    else
      flash[:danger] = "Invalid user_name/password conbination"
      render 'sessions/new'
    end
  end

  def destroy
    user = User.find(params[:id])
    session.delete(:user_id)
    redirect_to root_path
  end
end
