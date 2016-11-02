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
end
