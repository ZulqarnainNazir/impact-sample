class ToDoNotificationSetting < ActiveRecord::Base
  belongs_to :user
  belongs_to :business

  enum overdue_reminder_interval: [:weekly, :daily]

  def notify(message, notifiable, to_do)
    if send(notifiable) # notiable represents a boolean field on this model
      ToDoNotificationMailer.notify(message: message, user: user, to_do: to_do,
                                    business: business).deliver_later
    end
  end
end
