class EventFeedDefaultImageCopyJob < ApplicationJob
  queue_as :default

  def perform(event_feed_id)
    event_feed = EventFeed.find(event_feed_id)
    return unless event_feed.default_event_image

    imported_events_with_images = event_feed.imported_event_definitions.joins(:main_image)
    imported_events_without_images = event_feed.imported_event_definitions.where.not(id: imported_events_with_images.ids)
    imported_events_without_images.each do |event_without_image|
      event_without_image.main_image = event_feed.default_event_image
      event_without_image.event_image = event_feed.default_event_image
    end
  end
end
