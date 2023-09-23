class CommentsController < ApplicationController

  def index
  end

  def show
  end

  def edit
  end

  def create
    @track = Track.find(params[:track_id])
    @comment = @track.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = t('messages.create_success', model: Comment.model_name.human)
      redirect_to track_path(@track)
    else
      flash.now[:alert] = t('messages.create_failure', model: Comment.model_name.human)
      render 'tracks/show'
    end

  end

  def destroy
    current_user.comments.find(params[:id]).destroy!
    flash[:notice] = t('messages.delete_success', model: Comment.model_name.human)
    redirect_to track_path(params[:track_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end
