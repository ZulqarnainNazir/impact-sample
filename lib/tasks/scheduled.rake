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

  desc 'Trigger mission due notification emails'
  task trigger_mission_due_notifications: :environment do
    admin_ids = User.where(super_user: true).pluck(:id)

    # Notify about due scheduled mission instances
    scheduled_missions = MissionInstance.includes(business: :users)
                                        .scheduled
                                        .joins(:mission_instance_events)
                                        .where(mission_instance_events: { occurs_on: Date.today })
    scheduled_missions.each do |sm|
      business_users = sm.business.users.reject { |user| admin_ids.include?(user.id) }
      business_users.each do |user|
        MissionNotificationMailer.mission_due(
          user: user,
          mission_instance: sm
        ).deliver_now
      end
    end

    # Notify about due one time mission instances

    one_time_missions = MissionInstance.includes(business: :users)
                                       .one_time
                                       .where(start_date: Date.today)
    one_time_missions.each do |otm|
      business_users = otm.business.users.reject { |user| admin_ids.include?(user.id) }
      business_users.each do |user|
        MissionNotificationMailer.mission_due(
          user: user,
          mission_instance: otm
        ).deliver_now
      end
    end
  end
end
