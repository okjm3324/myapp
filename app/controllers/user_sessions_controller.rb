class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create new] 
  def new
  end

  def create
    reset_session 
    @user = login(params[:email], params[:password])
    if @user
      redirect_to(user_path(@user), notice: 'ログインに成功しました')
    else
      flash[:alert] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_to(root_path,status: :see_other, notice: 'ログアウトしました')
  end
end
