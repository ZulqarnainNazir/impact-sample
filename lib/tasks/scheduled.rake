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

    overdue_to_dos = ToDo.includes(:to_do_notification_settings).active.overdue.pending
    overdue_to_dos.each do |to_do|
      next unless to_do.business.to_dos_enabled
      business_users = to_do.business.users.where.not(id: admin_ids)

      to_do.notify_authorized_business_users(
        business_users,
        "'#{to_do.title}' is overdue",
        :due
      )
    end

    due_to_dos = ToDo.includes(:to_do_notification_settings).active.due_now.pending
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

  def trigger_summary_new_follower_emails(name, default_time_window, min_time_window)
    admin_ids = User.where(super_user: true).pluck(:id)
    job = SummaryJob.find_by_name("#{name}_followers")

    last_run_at = job.last_run_at
    if (last_run_at.blank?)
      puts 'Run over default period'
      cutoff = (Time.now - default_time_window)
    elsif (last_run_at > Time.now - min_time_window)
      puts 'Not running, too soon'
      puts "#{last_run_at} greater than #{Time.now - min_time_window}"
      return
    else
      puts 'Running over time since last run'
      puts last_run_at
      cutoff = last_run_at
    end

    job.last_run_at = Time.now
    job.save!

    new_listings = CompanyListCompany.where("created_at > ?", cutoff)

    businesses_to_notify = new_listings.map { |l| l.company.business }.uniq

    puts "Notifying #{businesses_to_notify.size} businesses"

    businesses_to_notify.each do |business|
      puts "...Business #{business.id}"
      users = business.authorizations.reject { |auth|
        auth.follower_notifications != name ||
        false # admin_ids.include?(auth.user.id)
      }.map { |auth| auth.user }

      puts "...Notifying #{users.size} users"
      return unless users.size > 0

      follower_businesses = business.listed_by_business.where(
        'company_list_companies.created_at > ?', cutoff
      ).map { |l| l.company_list.business }

      users.each do |user|
        puts "......User #{user.id} has #{follower_businesses.size} new followers"
        FollowerNotificationMailer.summary_email(
          user: user,
          business: business,
          follower_businesses: follower_businesses
        ).deliver_now
      end
    end
  end

  desc 'Trigger hourly new follower emails'
  task trigger_hourly_new_follower_emails: :environment do
    trigger_summary_new_follower_emails('hourly', 60 * 60, 60 * 55)
  end

  desc 'Trigger daily new follower emails'
  task trigger_daily_new_follower_emails: :environment do
    trigger_summary_new_follower_emails('daily', 3600 * 24, 3600 * 23)
  end

  desc 'Trigger weekly new follower emails'
  task trigger_weekly_new_follower_emails: :environment do
    trigger_summary_new_follower_emails('weekly', 86400 * 7, 86400 * 6.5)
  end

  desc 'Remove suspicious users'
  task remove_suspicious_users: :environment do
    suspicious_email_domains = ENV.fetch('EMAIL_DOMAINS', 'tutanota.com,protonmail.com,inbox.lv,zoho.eu,netcourrier.com,mailfence.com,zoho.com,scryptmail.com,seznam.cz,msgsafe.io,fastmail.com')
    suspicious_email_domains = suspicious_email_domains.split(',')
    suspicious_email_domains.each do |suspicious_email_domain|
      suspicious_users = User.where('users.email LIKE ?', "%@#{suspicious_email_domain}")
      puts "Found #{suspicious_users.count} users with the #{suspicious_email_domain} domain"
      suspicious_users.each do |suspicious_user|
        puts "Destroying #{suspicious_user.attributes.slice('id', 'first_name', 'last_name', 'email').to_json}"
        suspicious_user.destroy
      end
    end
  end
end
