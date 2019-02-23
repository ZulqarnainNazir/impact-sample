require 'icalendar'

module Feeds
  module Parsers
    class IcalFileParser < IcalParser
      def parse(url)
        cal_file = open(url)
        calendars = Icalendar::Calendar.parse(cal_file)
        calendars.map do |calendar|
          calendar.events.map do |event|
            event_from_entry(event)
          end
        end.flatten
      end

      def event_from_entry(event)
        byebug
        Feeds::Event.new({
          event_id: event.uid.to_s,
          title: event.summary&.to_s.try(:force_encoding, 'utf-8'),
          summary: event.description&.to_s.try(:force_encoding, 'utf-8'),
          start_date: event.dtstart&.to_datetime,
          end_date: event.dtend&.to_datetime,
          location: get_location(event.location)
        })
      end
    end
  end
end
