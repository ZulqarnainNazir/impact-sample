namespace :scheduled do
  desc 'Mark missions overdue by 3 days as skipped'
  # bundle exec rake scheduled:skip_missions_too_long_overdue OVERDUE_NUM=3
  task skip_missions_too_long_overdue: :environment do
    @overdue_num = ENV['OVERDUE_NUM']&.to_i || 3
    @overdue_date = Date.today - @overdue_num

    admin_ids = User.where(super_user: true).pluck(:id)

    scheduled_missions = MissionInstance.created_or_active
                                        .recurring_missions_due_on(@overdue_date)

    one_time_missions = MissionInstance.created_or_active
                                       .one_time_missions_due_on(@overdue_date)

    puts "Automatically skipping #{scheduled_missions.length} scheduled missions and #{one_time_missions.length} one time missions."

    [scheduled_missions, one_time_missions].each do |batch|
      batch.each do |mi|
        mi.mark_skipped

        if mi.scheduled?
          mi.mission_instance_events
            .incomplete
            .occurs_on(@overdue_date)
            .update_all(status: 'skipped')
        end

        mi.mission_histories.create!(
          action: 'skipped',
          happened_at: Time.zone.now,
          description: "We automatically marked this Mission instance as skipped because it was 3-days overdue."
        )
      end
    end
  end

  desc 'Trigger summary todo notification emails'
  task trigger_summary_todo_notifications: :environment do
    admin_ids = User.where(super_user: true).map(&:id)

    overdue_to_dos = ToDo.includes(:to_do_notification_settings).active.overdue
    overdue_to_dos.each do |to_do|
      next unless to_do.business.to_dos_enabled
      business_users = to_do.business.users.where.not(id: admin_ids)

      to_do.notify_authorized_business_users(
        business_users,
        "'#{to_do.title}' is overdue",
        :due
      )
    end

    due_to_dos = ToDo.includes(:to_do_notification_settings).active.due_now
    due_to_dos.each do |to_do|
      next unless to_do.business.to_dos_enabled
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
                                        .created_or_active
                                        .joins(:mission_instance_events)
                                        .where(mission_instance_events: { occurs_on: Date.today })
    scheduled_missions.each do |sm|
      business_users = sm.business.users.reject { |user| admin_ids.include?(user.id) }
      business_users.each do |user|
        next unless sm.mission

        MissionNotificationMailer.mission_due(
          user: user,
          business: sm.business,
          mission_instance: sm
        ).deliver_now
      end
    end

    # Notify about due one time mission instances

    one_time_missions = MissionInstance.includes(business: :users)
                                       .created_or_active
                                       .one_time
                                       .where(start_date: Date.today)
    one_time_missions.each do |otm|
      business_users = otm.business.users.reject { |user| admin_ids.include?(user.id) }
      business_users.each do |user|
        next unless otm.mission

        MissionNotificationMailer.mission_due(
          user: user,
          business: otm.business,
          mission_instance: otm
        ).deliver_now
      end
    end
  end

  desc 'Trigger missions due today notification emails'
  task trigger_missions_due_today_notifications: :environment do
    admin_ids = User.where(super_user: true).pluck(:id)

    Business.all.each do |business|
      missions = MissionInstance.missions_due_today(business).created_or_active

      next unless missions.any?

      business_users = business.users.reject { |user| admin_ids.include?(user.id) }
      business_users.each do |user|
        # Skip for users who have disabled this notification
        next unless user.mission_notification_setting&.daily_due_notification

        if user.mission_notification_setting&.mine_daily?
          # In this case we have to do special logic to pull only assigned
          my_missions = MissionInstance.missions_due_today(business)
                                       .created_or_active
                                       .where(assigned_user: user)

          next unless my_missions.any? { |mi| mi.mission.present? }

          MissionNotificationMailer.missions_due_today(
            business: business,
            user: user,
            mission_instances: my_missions
          ).deliver_now
        elsif user.mission_notification_setting&.all_daily?
          next unless missions.any? { |mi| mi.mission.present? }

          MissionNotificationMailer.missions_due_today(
            business: business,
            user: user,
            mission_instances: missions
          ).deliver_now
        end
      end
    end
  end

  desc 'Trigger missions due this week notification emails'
  task trigger_missions_due_weekly_notifications: :environment do
    if Time.now.monday?
      admin_ids = User.where(super_user: true).pluck(:id)

      Business.all.each do |business|
        missions = MissionInstance.missions_due_this_week(business).created_or_active
        prompts = MissionInstance.dashboard_prompts(business, 3, true)

        next if missions.empty? && prompts.empty?

        business_users = business.users.reject { |user| admin_ids.include?(user.id) }
        business_users.each do |user|
          # Skip for users who have disabled this notification
          next unless user.mission_notification_setting&.weeky_due_notification

          if user.mission_notification_setting&.mine_weekly?
            # In this case we have to do special logic to pull only assigned
            my_missions = MissionInstance.missions_due_this_week(business)
                                         .created_or_active
                                         .where(assigned_user: user)

            next if my_missions.empty? && prompts.empty?
            next unless my_missions.any? { |mi| mi.mission.present? }

            MissionNotificationMailer.missions_due_this_week(
              user: user,
              business: business,
              prompts: prompts,
              mission_instances: my_missions
            ).deliver_now
          elsif user.mission_notification_setting&.all_weekly?
            next if missions.empty? && prompts.empty?
            next unless missions.any? { |mi| mi.mission.present? }

            MissionNotificationMailer.missions_due_this_week(
              user: user,
              business: business,
              prompts: prompts,
              mission_instances: missions
            ).deliver_now
          end
        end
      end
    end
  end

  desc 'Trigger mission summary notification emails'
  task trigger_mission_summary_notifications: :environment do
    admin_ids = User.where(super_user: true).pluck(:id)

    Business.all.each do |business|
      prompts = MissionInstance.dashboard_prompts(business, 3, true)

      business_users = business.users.reject { |user| admin_ids.include?(user.id) }
      business_users.each do |user|
        setting = MissionNotificationSetting.find_or_create_by(business: business, user: user)

        # Skip for users who have disabled this notification
        next unless setting.suggestions_notification
        next unless setting.summary_schedule && setting.summary_schedule.occurs_on?(Date.today)

        since = setting.summary_schedule.previous_occurrence(Time.now - 100.days)
        to = setting.summary_schedule.previous_occurrence(Time.now - 100.days)

        # In this case we have to do special logic to pull only assigned
        completed = MissionInstance.completed_between(since, to).where(business: business)
        due = MissionInstance.due_between(since, to).where(business: business).created_or_active

        next if completed.empty? && due.empty?

        MissionNotificationMailer.summary_email(
          prompts: prompts,
          user: user,
          business: business,
          completed: completed,
          due: due
        ).deliver_now
      end
    end
  end

  desc 'Trigger mission suggestions notification emails'
  task trigger_mission_suggestions_notifications: :environment do
    admin_ids = User.where(super_user: true).pluck(:id)

    Business.all.each do |business|
      prompts = MissionInstance.dashboard_prompts(business, 3, true)

      business_users = business.users.reject { |user| admin_ids.include?(user.id) }
      business_users.each do |user|
        setting = MissionNotificationSetting.find_or_create_by(business: business, user: user)

        # Skip for users who have disabled this notification
        next unless setting.suggestions_notification
        next unless setting.suggestions_schedule && setting.suggestions_schedule.occurs_on?(Date.today)
        next unless prompts.any? { |mi| mi.mission.present? }

        MissionNotificationMailer.suggestions_email(prompts: prompts, business: business, user: user).deliver_now
      end
    end
  end
end
