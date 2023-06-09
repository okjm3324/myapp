class UsersController < ApplicationController
  def new
  @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_to :new
    else
      render :new
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
