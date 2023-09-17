class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create new spotify_callback refresh_spotify_access_token] 
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

  def spotify_callback
    bind
    auth_hash = request.env['omniauth.auth']
    access_token = auth_hash['credentials']['token']
    refresh_token = auth_hash['credentials']['refresh_token']
    token_deadline = auth_hash['credentials']['expires_at']

    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # アクセストークンとリフレッシュトークンをセッションに保存
    session[:access_token] = access_token
    session[:refresh_token] = refresh_token
    session[:token_deadline] = token_deadline
    
    if User.find_by(email: spotify_user.email)
      #ユーザーがある場合ログイン画面へ
      redirect_to login_path
    else
      #ユーザー新規登録画面へ
      session[:spotify_user_info] = {
        name: spotify_user.display_name,
        email: spotify_user.email,
        images: spotify_user.images,
        id: spotify_user.id
      }
      redirect_to new_user_path
    end
   
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
