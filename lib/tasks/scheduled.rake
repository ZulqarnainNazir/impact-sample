namespace :scheduled do
  desc 'Trigger summary todo notification emails'
  task trigger_summary_todo_notifications: :environment do
    overdue_to_dos = ToDo.includes(:to_do_notification_settings).active.submitted.overdue
    overdue_to_dos.each do |to_do|
      to_do.to_do_notification_settings.each do |setting|
        if setting.weekly?
          if Time.now.monday?
            to_do.notify_all_of_status_change("'#{to_do.title}' is overdue", :due)
          end
        else
          to_do.notify_all_of_status_change("'#{to_do.title}' is overdue", :due)
        end
      end
    end

    due_to_dos = ToDo.includes(:to_do_notification_settings).active.submitted.due_now
    due_to_dos.each do |to_do|
      to_do.to_do_notification_settings.each do |setting|
        if setting.weekly?
          if Time.now.monday?
            to_do.notify_all_of_status_change("'#{to_do.title}' is almost due", :deadline_approaching)
          end
        else
          to_do.notify_all_of_status_change("'#{to_do.title}' is almost due", :deadline_approaching)
        end
      end
    end
  end
end
