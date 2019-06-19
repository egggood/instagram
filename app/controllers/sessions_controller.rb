class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to user_path(session[:user_id])
    end
  end

  def create
    user = User.find_by(user_name: params[:session][:user_name])
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user if params[:session][:remember_me] == '1'
      flash[:success] = "ログインに成功しました^ ^"
      redirect_to user
    else
      flash[:danger] = "Invalid user_name/password conbination"
      render 'sessions/new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
