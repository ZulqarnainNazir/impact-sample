class ToDoNotificationSetting < ActiveRecord::Base
  belongs_to :user
  belongs_to :business

  enum overdue_reminder_interval: [:weekly, :daily]

  def notify(message, notifiable, to_do)
    if send(notifiable) # notiable represents a boolean field on this model
      if notifiable_is_scheduled?(notifiable)
        send_notification(message, to_do) if scheduled_and_ready?(notifiable)
      else
        send_notification(message, to_do)
      end
    end
  end

  def send_notification(message, to_do)
    ToDoNotificationMailer.notify(message: message, user: user, to_do: to_do,
                                  business: business).deliver_now
  end

  def scheduled_and_ready?(notifiable)
    return true if daily?

    Time.now.monday?
  end

  def notifiable_is_scheduled?(notifiable)
    notifiable == :due || notifiable == :deadline_approaching
  end
end
