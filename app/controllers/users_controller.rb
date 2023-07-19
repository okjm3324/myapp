class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[create new] 
  def index

  end

  def new
  @user = User.new
  end

  def show
    @user = User.includes(tracks: {song: :album}).find_by(id: params[:id])
    @tracks = @user.tracks

  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path
      flash[:notice] = 'ユーザーの作成に成功しました'
    else
      flash.now[:alert] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      @user.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
      redirect_to @user, notice: "ユーザー情報を更新しました。"
    else
      flash.now[:alert] = 'ユーザー情報を更新に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :instrument, :avatar)
  end
end
