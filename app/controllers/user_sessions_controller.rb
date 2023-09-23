class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create new spotify_callback refresh_spotify_access_token] 
  before_action :check_login, only: %i[new]
  def new
  end

  def create
    reset_session 
    @user = login(params[:email], params[:password])
    if @user
      redirect_to(user_path(@user), notice: t('messages.login_success'))
    else
      flash[:alert] = t('messages.login_failure')
      render :new
    end
  end

  def destroy
    logout
    redirect_to(root_path,status: :see_other, notice: t('messages.logout_success'))
  end

  def spotify_callback
    user = User.find_or_create_from_omniauth!(request.env["omniauth.auth"])
    auto_login(user)
    redirect_to user_path(user)
  end

  def refresh_spotify_access_token
    # SpotifyのAPIを呼び出してリフレッシュトークンを使用して新しいアクセストークンを取得する処理
    # ここでは具体的な実装を省略しています
    new_access_token = refresh_access_token(session[:refresh_token])

    # 新しいアクセストークンをセッションに保存
    session[:access_token] = new_access_token
    
    redirect_to root_path
  end
end
