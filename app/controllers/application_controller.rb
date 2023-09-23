class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    redirect_to login_path, alert: t("messages.login_caution")
  end

  def check_login
    redirect_to user_path(current_user) if current_user
  end

  def check_and_refresh_token
    # current_userがnilでない、かつトークンの期限が存在することを確認
    return if current_user.nil? || current_user.token_deadline.nil?

    # 期限が現在の時間よりも前である場合、トークンをリフレッシュ
    if Time.current > Time.at(current_user.token_deadline)
      current_user.refresh_spotify_token!
    end
  end
end
