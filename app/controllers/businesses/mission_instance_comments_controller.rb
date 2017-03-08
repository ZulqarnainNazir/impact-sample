class Businesses::MissionInstanceCommentsController < Businesses::BaseController
  def create
    @mission = Mission.find(params[:mission_id])
    @mission_instance = MissionInstance.find_or_create_by(
      mission_id: params[:mission_id],
      business_id: @business.id
    )
    @comment = @mission_instance.comments.build(comment_params)
    @comment.commenter = current_user

    if @comment.save
      redirect_to :back, notice: 'Comment added'
    else
      redirect_to :back, error: 'Failed to add comment'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
