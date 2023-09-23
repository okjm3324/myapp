class LikesController < ApplicationController
  def index
    @user_likes = current_user.likes.includes(:track)
  end

  def create
    track = Track.find(params[:track_id])
    like = current_user.likes.new(track_id: track.id)
    redirect_to request.referer if like.save
  end

  def destroy
    track = Track.find(params[:track_id])
    like = current_user.likes.find_by(track_id: track.id)
    like.destroy
    redirect_to request.referer
  end
end
