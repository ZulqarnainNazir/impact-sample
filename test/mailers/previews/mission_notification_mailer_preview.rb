class MissionNotificationMailerPreview < ActionMailer::Preview
  include ActionView::Helpers::TextHelper

  def mission_due
    MissionNotificationMailer.mission_due(
      user: User.first,
      business: Business.first,
      mission_instance: MissionInstance.first
    )
  end

  def missions_due_today
    MissionNotificationMailer.missions_due_today(
      user: User.first,
      business: Business.first,
      mission_instances: MissionInstance.first(5)
    )
  end

  def missions_due_this_week
    MissionNotificationMailer.missions_due_this_week(
      user: User.first,
      business: Business.first,
      prompts: MissionInstance.last(3),
      mission_instances: MissionInstance.first(5)
    )
  end

  def summary_email
    MissionNotificationMailer.summary_email(
      user: User.first,
      business: Business.first,
      due: MissionInstance.last(3),
      prompts: MissionInstance.last(3),
      completed: MissionInstance.completed.first(3)
    )
  end

  def new_comment
    MissionNotificationMailer.new_comment(
      user: User.first,
      business: Business.first,
      mission_instance: MissionInstance.first,
      comment: Comment.first
    )
  end
end
