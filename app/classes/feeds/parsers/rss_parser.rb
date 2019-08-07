# This parser process RSS/XML feeds

module Feeds
  module Parsers
    class RssParser < Feeds::BaseParser
      def parse(feed)
        Feedjira::Feed.fetch_and_parse(feed.url).entries.map do |entry|
          event_from_entry(entry, feed)
        end
      end

      #TODO - This should probably be expanded as the default?
      def event_from_entry(entry, feed)
        Feeds::Event.new entry.to_h.merge(
          summary: Nokogiri::HTML(entry.summary).text,
          event_id: digest(entry.to_json)
        )
      end
    end
  end
end
