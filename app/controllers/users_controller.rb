class UsersController < ApplicationController
  before_action :logged_in_user,only:[:edit,:update, :destroy]
  before_action :correct_user, only:[:edit, :update, :destroy]
  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "登録に成功しました!"
      log_in @user
      redirect_to @user
    else
      render 'users/new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
     @user = User.find(params[:id])
     if @user.update_attributes(user_params)
       flash[:success] = "更新に成功しました！"
       redirect_to @user
     else
       render 'users/edit'
     end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    log_out
    redirect_to root_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :user_name, :password,
                                 :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless @user == current_user
  end

end
