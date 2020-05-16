# This parser process ical feeds via an ICS file

module Feeds
  module Parsers
    class VisitCharleVoixParser < Feeds::BaseParser
      def parse(feed)
        events_from_url = JSON.load(open(feed.url))
        events_from_url.map do |event|
            event_from_entry(event, feed)
        end.flatten
      end

      def event_from_entry(event, feed)
        # byebug
        Feeds::Event.new({
          event_id: event["id_events"],
          title: event["name"].to_s,
          summary: event["description"].to_s,
          start_date: event["start_date"].to_datetime.strftime("%Y-%m-%d"), 
          start_time: parse_time(feed, event["start_date"].to_datetime.strftime("%H:%M"), event["start_date"].to_datetime.strftime("%Y-%m-%d")),
          end_date: event["end_date"].to_date.strftime("%Y-%m-%d"),
          end_time: parse_time(feed, event["end_date"].to_datetime.strftime("%H:%M"), event["end_date"].to_datetime.strftime("%Y-%m-%d")),
          location: get_location(event["address"]+" "+event["city"]+" "+event["state"]),
        })
      end
    end
  end
end
