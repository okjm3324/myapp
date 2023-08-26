class CommentsController < ApplicationController

  def index
  end

  def show
  end

  def create
    @track = Track.find(params[:track_id])
    @comment = @track.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = "コメントしました"
      # redirect_back(fallback_location: root_path)
      redirect_to track_path(@track)
    else
      flash[:alert] = "コメントできませんでした"
      render 'tracks/show'
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
