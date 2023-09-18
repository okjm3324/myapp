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
    auth_hash = request.env['omniauth.auth']
    access_token = auth_hash['credentials']['token']
    refresh_token = auth_hash['credentials']['refresh_token']
    token_deadline = auth_hash['credentials']['expires_at']

    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # アクセストークンとリフレッシュトークンをセッションに保存
    session[:access_token] = access_token
    session[:refresh_token] = refresh_token
    session[:token_deadline] = token_deadline
    
    user = User.find_by(email: spotify_user.email)
    if user
      #ログイン処理をする
      reset_session 
      if auto_login(user)
        redirect_to(user_path(user), notice: 'ようこそ')
      else
        flash[:alert] = 'ログインに失敗しました'
        redirect_to login_path
      end

    else
      #ユーザー新規登録をする
      session[:spotify_user_info] = {
        name: spotify_user.display_name,
        email: spotify_user.email,
        images: spotify_user.images,
        id: spotify_user.id
      }
      random_password = SecureRandom.hex(16)
      user_params = {
        email: spotify_user.email,
        name: spotify_user.display_name,
        instrument: 0, # この値はあなたが定義するものに依存します
        user_code: spotify_user.id, # ユニークなユーザーコードを生成する方法として SecureRandom.hex を使用しています
        password: random_password,
        password_confirmation: random_password,
        access_token: access_token,
        refresh_access_token: refresh_token,
        token_deadline: token_deadline,
      }
      ##ここでユーザーをクリエイトしてしまう
      @user = User.new(user_params)
      
      if @user.save
        reset_session 
        auto_login(@user) 
        flash[:notice] = 'ようこそ'
        redirect_to user_path(@user)
      else
        flash[:alert] =  @user.errors.full_messages.join(", ")
        redirect_to login_path
      end
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
