class Businesses::CommentsController < Businesses::BaseController
  def create
    @to_do = ToDo.find(params[:to_do_id])
    @comment = @to_do.comments.build(comment_params.merge(commenter: current_user))

    @comment.save

    redirect_to business_to_do_path(@business, @to_do)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
