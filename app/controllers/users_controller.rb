class UsersController < ApplicationController
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
      redirect_to @user
    else
      #raise
      render 'users/new'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.delete
    redirect_to root_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :user_name, :password,
                                 :password_confirmation)
  end
end
