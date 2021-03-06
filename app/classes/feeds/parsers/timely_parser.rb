# This parse processes Timely feeds using XML

module Feeds
  module Parsers
    class TimelyParser < Feeds::BaseParser
      def parse(feed)
        xml = URI(feed.url).read

        events = Hash.from_xml(xml).dig('vcalendar', 'vevent')
        events.map do |entry|
          event_from_entry(entry, feed)
        end
      end

      def event_from_entry(entry, feed)
        Feeds::Event.new({
          event_id: entry.dig('uid'),
          title: entry.dig('summary').try(:force_encoding, 'utf-8'),
          summary: entry.dig('description').try(:to_s).try(:force_encoding, 'utf-8'),
          start_date: entry.dig('dtstart').try(:to_datetime),
          end_date: entry.dig('dtend').try(:to_datetime),
          location: get_location(entry.dig('location'))
        })
      end
    end
  end
end
