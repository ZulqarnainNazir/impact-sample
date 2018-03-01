class MissionNotificationMailerPreview < ActionMailer::Preview
  include ActionView::Helpers::TextHelper

  def setup_preview
    unless @user = User.find_by(super_user: false)
      @user = PopulateUser.run
    end
    unless @business = @user.businesses.first
      @business = PopulateBusiness.run(@user)
    end
    @mission_instances = MissionInstance.first(8)
    if @mission_instances.count < 8
      @mission_instances = PopulateMissionInstance.run(@business, 8)
    end
    @comment = PopulateComment.run(@mission_instances.first, @user)
  end

  def mission_due
    setup_preview
    MissionNotificationMailer.mission_due(
      user: @user,
      business: @business,
      mission_instance: @mission_instances.first
    )
  end

  def missions_due_today
    setup_preview
    MissionNotificationMailer.missions_due_today(
      user: @user,
      business: @business,
      mission_instances: @mission_instances.first(5)
    )
  end

  def missions_due_this_week
    setup_preview
    MissionNotificationMailer.missions_due_this_week(
      user: @user,
      business: @business,
      prompts: @mission_instances.last(3),
      mission_instances: @mission_instances.first(5)
    )
  end

  def summary_email
    setup_preview
    MissionNotificationMailer.summary_email(
      user: @user,
      business: @business,
      due: @mission_instances.last(3),
      prompts: @mission_instances.last(3),
      completed: MissionInstance.completed.first(3)
    )
  end

  def suggestions_email
    setup_preview
    MissionNotificationMailer.suggestions_email(
      user: @user,
      business: @business,
      prompts: @mission_instances.last(3),
    )
  end

  def new_comment
    setup_preview
    MissionNotificationMailer.new_comment(
      user: @user,
      business: @business,
      mission_instance: @mission_instances.first,
      comment: @comment
    )
  end
end
