class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[create new] 
  def new
  @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path
      flash[:notice] = 'ユーザーの作成に成功しました'
    else
      flash.now[:alert] = 'ユーザーの作成に失敗しました'
      render :new, status: 422
    end
  end

  def edit

  end

  def destroy

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :instrument)
  end
end
