class FeedImportJob < ApplicationJob
  queue_as :default

  def perform(event_feed_id, always_notify = true)
    event_feed = EventFeed.find(event_feed_id)
    Feeds::ImportService.new(event_feed: event_feed, always_notify: always_notify).run
  end
end
