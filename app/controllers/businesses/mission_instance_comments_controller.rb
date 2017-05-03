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
      notify_users_about_comment

      redirect_to :back, notice: 'Comment added'
    else
      redirect_to :back, error: 'Failed to add comment'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def notify_users_about_comment
    setting = @business.mission_notification_setting

    return if setting && !setting.comment_notification

    @business.users.each do |user|
      MissionNotificationMailer.new_comment(
        user: current_user,
        business: @business,
        mission_instance: @mission_instance,
        comment: @comment
      ).deliver_now
    end
  end
end
