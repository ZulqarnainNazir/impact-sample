namespace :data_migrations do
  desc 'Remove duplicate to do notification settings'
  task remove_duplicate_settings: :environment do
    User.all.each do |user|
      Business.all.each do |business|
        settings = user.to_do_notification_settings.where(business: business)

        if settings.any?
          keep = settings.order('updated_at DESC').first

          settings.where.not(id: keep.id).destroy_all
        end
      end
    end
  end

  desc 'Reset completion rate for all one time missions'
  task reset_one_time_mission_completion_rates: :environment do
    MissionInstance.one_time.each do |mission_instance|
      if mission_instance.completed?
        mission_instance.mark_complete
      elsif mission_instance.skipped?
        mission_instance.mark_skipped
      elsif mission_instance.snoozed?
        mission_instance.mark_snoozed
      end
    end
  end
end
