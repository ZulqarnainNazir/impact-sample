module EventFeedHelper
  def fields_with_errors(model)
    model.valid?(:feed_overview)
    model.errors.keys.map { |k| k.to_s.humanize }.join(', ')
  end

  def feed_type(event_feed)
    case event_feed.url
    when /\.rss|\.xml/
      'RSS/XML'
    when /\.ics/
      'ICAL/ICS'
    when /timely/
      'TIMELY'
    when /google\.com\/calendar\/v3/
      'GOOGLE'
    else
      'Custom'
    end
  end
end
