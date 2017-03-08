class MissionNotificationMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def mission_due(args)
    @user = args[:user]
    @mission_instance = args[:mission_instance]

    mail to: @user.email, subject: 'Your Marketing Mission is due'
  end
end
