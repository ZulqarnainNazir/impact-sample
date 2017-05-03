class MissionNotificationMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  layout 'mission_notification_mailer'

  def mission_due(args)
    @user = args[:user]
    @mission_instance = args[:mission_instance]
    @business = args[:business]

    mail to: @user.email, subject: 'Your Marketing Mission is due'
  end

  def missions_due_today(args)
    @user = args[:user]
    @mission_instances = args[:mission_instances]
    @business = args[:business]

    mail to: @user.email, subject: 'You have missions due today'
  end

  def missions_due_this_week(args)
    @user = args[:user]
    @mission_instances = args[:mission_instances]
    @prompts = args[:prompts]
    @business = args[:business]

    mail to: @user.email, subject: 'You have missions due this week'
  end

  def summary_email(args)
    @user = args[:user]
    @due = args[:due]
    @business = args[:business]
    @completed = args[:completed]
    @prompts = args[:prompts]

    mail to: @user.email, subject: 'Marketing Mission Summary'
  end

  def suggestions_email(args)
    @user = args[:user]
    @business = args[:business]
    @prompts = args[:prompts]

    mail to: @user.email, subject: 'Marketing Suggestions'
  end

  def new_comment(args)
    @user = args[:user]
    @business = args[:business]
    @mission_instance = args[:mission_instance]
    @comment = args[:comment]

    mail to: @user.email, subject: 'New comment on mission'
  end
end
