# These tasks change feed content widgets and blocks from having content settings for just Job, to more
# granular settings for PaidJob or VolunteerJob.
# 
# See https://github.com/brianmba/impact-app/pull/600 for context.
# 
# Migration usage:
#   bundle exec rake one_time_tasks:migrate_job_settings_for_paid_and_volunteer
# 
# Rollback usage:
#   bundle exec rake one_time_tasks:rollback_job_settings_for_paid_and_volunteer
# 
namespace :one_time_tasks do
  task migrate_job_settings_for_paid_and_volunteer: :environment do
    ContentFeedWidget.find_in_batches do |batch|
      batch.each do |feed_widget|
        if feed_widget.content_types.include?('Job')
          puts "Migrating ContentFeedWidget##{feed_widget.id} to have both PaidJob and VolunteerJob"
          content_types = feed_widget.content_types
          content_types.delete('Job')
          content_types << 'PaidJob'
          content_types << 'VolunteerJob'
          feed_widget.content_types = content_types
          feed_widget.save
        end
      end
    end

    BlogFeedBlock.find_in_batches do |batch|
      batch.each do |block|
        puts "Migrating BlogFeedBlock##{block.id} to have both PaidJob and VolunteerJob"
        content_types = block.settings['content_types']&.split(' ')
        next unless content_types
        content_types.delete('Job')
        content_types << 'PaidJob'
        content_types << 'VolunteerJob'
        block.settings['content_types'] = content_types.join(' ')
        block.save
      end
    end
  end

  task rollback_job_settings_for_paid_and_volunteer: :environment do
    ContentFeedWidget.find_in_batches do |batch|
      batch.each do |feed_widget|
        if feed_widget.content_types.include?('PaidJob') ||
           feed_widget.content_types.include?('VolunteerJob')
          puts "Rolling back ContentFeedWidget##{feed_widget.id} to have just Job"
          content_types = feed_widget.content_types
          content_types.delete('PaidJob')
          content_types.delete('VolunteerJob')
          content_types << 'Job'
          feed_widget.content_types = content_types
          feed_widget.save
        end
      end
    end

    BlogFeedBlock.find_in_batches do |batch|
      batch.each do |block|
        puts "Rolling back BlogFeedBlock##{block.id} to have just Job"
        content_types = block.settings['content_types']&.split(' ')
        next unless content_types
        content_types.delete('PaidJob')
        content_types.delete('VolunteerJob')
        content_types << 'Job'
        block.settings['content_types'] = content_types.join(' ')
        block.save
      end
    end
  end
end
