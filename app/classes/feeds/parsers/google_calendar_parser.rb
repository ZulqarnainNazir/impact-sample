# This parser processes Google Calendar feeds via JSON
module Feeds
  module Parsers
    class GoogleCalendarParser < Feeds::BaseParser
      def parse(url)
        doc = open(url).read
        json = JSON.parse(doc)
        json.dig('items').map do |entry|
          event_from_entry(entry)
        end
      end

      def event_from_entry(entry)
        Feeds::Event.new({
          event_id: "#{entry.dig('id')}#{entry.dig('iCalUID')}",
          url: entry.dig('htmlLink'),
          title: entry.dig('summary').try(:force_encoding, 'utf-8'),
          summary: entry.dig('description').try(:to_s).try(:force_encoding, 'utf-8'),
          start_date: entry.dig('start', 'date').try(:to_date),
          end_date: entry.dig('end', 'date').try(:to_date)
        })
      end
    end
  end
end
