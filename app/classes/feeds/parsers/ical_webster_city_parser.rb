# Extends the base iCal parser for Webster City School District (RSchool) & Webster City Town Hall Calendar
# TODO - Extract Town Hall Calenadar to Timely

require 'icalendar'

module Feeds
  module Parsers
    class IcalWebsterCityParser < IcalParser
      SECONDS_IN_HOUR = 3600

      def event_from_entry(event, feed)
        location_name, location = event.location&.split('@')
        feed_event = Feeds::Event.new({
                                        event_id: event.uid.to_s,
                                        title: event.summary&.to_s.try(:force_encoding, 'utf-8'),
                                        summary: summary(event),
                                        start_date: event.dtstart,
                                        end_date: event.dtend,
                                        location: get_location(location&.squish, location_name&.squish),
                                        url: event.url,
                                      })

        if event_has_useful_time_information(event)
          feed_event.start_time = time_with_correction_for_offset(feed, event.dtstart) if event.dtstart
          feed_event.end_time = time_with_correction_for_offset(feed, event.dtend) if event.dtend
        elsif event.dtstart && event.dtstart == event.dtstart.beginning_of_day
          before_zone = Time.zone
          begin
            Time.zone = feed.time_zone
            feed_event.start_time = Time.zone.now.beginning_of_day
          ensure
            Time.zone = before_zone
          end
        end

        feed_event
      end

      def get_location(location_search, name = '')
        searches = MultiGeocoderService.search location_search || name
        search = searches.first

        return {} unless search.present?

        Feeds::Location.new({
          street1: search.address,
          city: search.city,
          state: search.state_code,
          zip_code: search.postal_code,
          name: name
        })
      end

      private

      def time_with_correction_for_offset(feed, datetime)
        # The Icalendar parsing gem returns the start and end times with a UTC offset leading our typical `parse_time`
        # logic to convert it into the appropriate timezone. But we don't want this conversion here.
        # This is corrected by adjusting the time by the offset associated with the feed's timezone.
        start_time = parse_time(feed, datetime, datetime)
        offset = start_time.utc_offset / SECONDS_IN_HOUR
        offset.positive? ? start_time - offset.hours : start_time + offset.abs.hours
      end

      def event_has_useful_time_information(event)
        return false unless event.dtstart && event.dtend
        return false if event.dtstart == event.dtend
        return false if (event.dtstart == event.dtstart.beginning_of_day) && (event.dtend == event.dtend.end_of_day)

        true
      end

      def summary(event)
        event.summary&.to_s.try(:force_encoding, 'utf-8') || event.summary&.to_s.try(:force_encoding, 'utf-8')
      end
    end
  end
end
