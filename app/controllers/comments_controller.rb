class CommentsController < ApplicationController

  def index
  end

  def show
  end

  def create
    binding.break
    track = Track.find(params[:track_id])
    @comment = track.comments.build(comment_params)
    binding.break
    @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = "コメントしました"
      redirect_back(fallback_location: root_path)

    else
      flash[:alert] = "コメントできませんでした"
      redirect_back(fallback_location: root_path)
    end

  end

  def edit
  end

  def destory
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end
