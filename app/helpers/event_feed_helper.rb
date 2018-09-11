module EventFeedHelper
  def fields_with_errors(model)
    model.valid?(:feed_overview)
    model.errors.keys.map { |k| k.to_s.humanize }.join(', ')
  end

  def feed_type(event_feed)
    case event_feed.url
    when /\.rss|\.xml/
      'RSS'
    when /\.ics/
      'ICAL'
    when /timely/
      'ICAL'
    when /google\.com\/calendar\/v3/
      'Google Calendar'
    end
  end
end
