# This parser process ical feeds via an ICS file
require 'icalendar'

module Feeds
  module Parsers
    class IcalParser < Feeds::BaseParser
      def parse(feed)
        cal_file = open(feed.url)
        calendars = Icalendar::Calendar.parse(cal_file)
        calendars.map do |calendar|
          calendar.events.map do |event|
            event_from_entry(event, feed)
          end
        end.flatten
      end

      def event_from_entry(event, feed)
        Feeds::Event.new({
          event_id: event.uid.to_s,
          title: event.summary.try(:to_s).try(:force_encoding, 'utf-8').strip,
          summary: event.description.try(:to_s).try(:force_encoding, 'utf-8').strip,
          start_date: event.dtstart,
          end_date: event.dtend,
          location: get_location(event.location),
        })
      end
    end
  end
end
