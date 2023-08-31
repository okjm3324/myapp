class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[create new] 
  def index

  end

  def new
  @user = User.new
  @spotify_user_info = session[:spotify_user_info]
  @email = @spotify_user_info['email']
  @name = @spotify_user_info['name']
  @image_url = @spotify_user_info['images'][0]['url']


  end

  def show
    @user = User.includes(tracks: {song: :album}).find_by(id: params[:id])
    if @user.tracks
      @tracks = @user.tracks
    end
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
    if @user.update(user_edit_params)
      @user.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
      redirect_to @user, notice: "ユーザー情報を更新しました。"
    else
      flash.now[:alert] = 'ユーザー情報を更新に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    session[:access_token] = @spotify_user.credentials.token
    session[:refresh_token] = @spotify_user.credentials.refresh_token
    # Now you can access user's private data, create playlists and much more
  end

  def likes
    @user = User.find(params[:id])
    likes = Like.where(user_id: @user.id).pluck(:track_id)
    @like_tracks = Track.find(likes)
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(10)
    render 'show_follow', status: :unprocessable_entity
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(10)
    render 'show_follow', status: :unprocessable_entity
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :instrument, :avatar).merge(
      access_token: session[:access_token],
      refresh_access_token: session[:refresh_token],
      user_code: session[:spotify_user_info]['id'] 
    )
  end

  def user_edit_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :instrument, :avatar)
  end
end
