# Extends the base iCal parser for Webster City School District (RSchool) & Webster City Town Hall Calendar
# TODO - Extract Town Hall Calenadar to Timely

require 'icalendar'

module Feeds
  module Parsers
    class IcalWebsterCityParser < IcalParser
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
        location_name, location = event.location&.split('@')
        Feeds::Event.new({
          event_id: event.uid.to_s,
          title: event.summary&.to_s.try(:force_encoding, 'utf-8'),
          summary: summary(event),
          start_date: event.dtstart,
          start_time: event.dtstart&.to_datetime,
          end_date: event.dtend,
          location: get_location(location&.squish, location_name&.squish),
          url: event.url,
        })
      end

      def get_location(location_search, name = '')
        searches = Geocoder.search location_search || name
        search = searches.first

        return {} unless search.present?

        Feeds::Location.new({
          street1: "#{search.house_number} #{search.street}",
          city: search.city,
          state: search.state_code,
          zip_code: search.postal_code,
          name: name
        })
      end

      private

      def summary(event)
        event.summary&.to_s.try(:force_encoding, 'utf-8') || event.summary&.to_s.try(:force_encoding, 'utf-8')
      end
    end
  end
end
