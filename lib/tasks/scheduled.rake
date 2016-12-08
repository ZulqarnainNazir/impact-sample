namespace :scheduled do
  desc 'Trigger summary todo notification emails'
  task trigger_summary_todo_notifications: :environment do
    admin_ids = User.where(super_user: true).map(&:id)

    overdue_to_dos = ToDo.includes(:to_do_notification_settings).active.overdue
    overdue_to_dos.each do |to_do|
      business_users = to_do.business.users.where.not(id: admin_ids)

      to_do.notify_authorized_business_users(
        business_users,
        "'#{to_do.title}' is overdue",
        :due
      )
    end

    due_to_dos = ToDo.includes(:to_do_notification_settings).active.due_now
    due_to_dos.each do |to_do|
      business_users = to_do.business.users.where.not(id: admin_ids)

      to_do.notify_authorized_business_users(
        business_users,
        "'#{to_do.title}' is almost due",
        :deadline_approaching
      )
    end
  end
end
