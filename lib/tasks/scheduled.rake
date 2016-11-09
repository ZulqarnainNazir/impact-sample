namespace :scheduled do
  desc 'Trigger summary todo notification emails'
  task trigger_summary_todo_notifications: :environment do
    overdue_to_dos = ToDo.includes(:to_do_notification_settings).active.overdue
    overdue_to_dos.each do |to_do|
      to_do.to_do_notification_settings.each do |setting|
        if setting.weekly?
          if Time.now.monday?
            setting.notify("'#{to_do.title}' is overdue", :due, to_do)
          end
        else
          setting.notify("'#{to_do.title}' is overdue", :due, to_do)
        end
      end
    end

    due_to_dos = ToDo.includes(:to_do_notification_settings).active.due_now
    due_to_dos.each do |to_do|
      to_do.to_do_notification_settings.each do |setting|
        if setting.weekly?
          if Time.now.monday?
            setting.notify("'#{to_do.title}' is almost due", :deadline_approaching, to_do)
          end
        else
          setting.notify("'#{to_do.title}' is almost due", :deadline_approaching, to_do)
        end
      end
    end
  end
end
