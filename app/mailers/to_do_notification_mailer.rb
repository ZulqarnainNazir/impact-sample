class ToDoNotificationMailer < ApplicationMailer
  def notify(args)
    @message = args[:message]
    @user = args[:user]
    @to_do = args[:to_do]

    @business = args[:business]

    mail to: @user.email, subject: @message
  end
end
