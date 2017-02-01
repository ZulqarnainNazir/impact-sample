class ToDoNotificationMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def notify(args)
    @message = args[:message]
    @user = args[:user]
    @to_do = args[:to_do]

    @business = args[:business]

    mail to: @user.email, subject: truncate(@message, length: 100, escape: false)
  end
end
