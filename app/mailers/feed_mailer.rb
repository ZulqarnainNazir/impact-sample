class FeedMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper
  layout 'mailer_theme_one'

  def import_finished(import_service, user, no_new_info = false)
    Rails.logger.info "FeedMailer sending for #{import_service.event_feed.id} to #{user.email}"

    @import_service = import_service
    @event_feed     = @import_service.event_feed
    @business       = @event_feed.business
    @no_new_info    = no_new_info

    mail to: user.email,
         from: "Buzz at Locable <#{Rails.application.secrets.buzz_email}>",
         subject: 'Your event feed import is complete'
  end
end
