class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[create new] 
  before_action :set_user, only: [:edit, :update, :likes, :following, :followers]
  
  def index; end

  def show
    @user = User.includes(tracks: {song: :album}).find_by(id: params[:id])
    @tracks = @user.tracks
  end

  def new
    @user = User.new
    @spotify_user_info = session[:spotify_user_info]
    @email = @spotify_user_info['email']
    @name = @spotify_user_info['name']
    @image_url = @spotify_user_info['images'][0]['url']
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path
      flash[:notice] = t('messages.success', model: User.model_name.human)
    else
      flash.now[:alert] = t('messages.failure', model: User.model_name.human)
      render :new
    end
  end

  def update
    if @user.update(user_edit_params)
      @user.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
      redirect_to @user, notice: t('messages.update_success', model: User.model_name.human)
    else
      flash.now[:alert] = t('messages.update_failure', model: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy; end

  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    session[:access_token] = @spotify_user.credentials.token
    session[:refresh_token] = @spotify_user.credentials.refresh_token
  end
  
  def likes
    likes = Like.where(user_id: @user.id).pluck(:track_id)
    @like_tracks = Track.find(likes)
  end

  def following
    @title = User.human_attribute_name(:following)
    @users = @user.following.page(params[:page]).per(10)
    render 'show_follow'
  end

  def followers
    @title = User.human_attribute_name(:followed)
    @users = @user.followers.page(params[:page]).per(10)
    render 'show_follow'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :instrument, :avatar).merge(
      access_token: session[:access_token],
      refresh_access_token: session[:refresh_token],
      token_deadline: session[:token_deadline],
      user_code: session[:spotify_user_info]['id'] 
    )
  end

  def user_edit_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :instrument, :avatar)
  end
end
