module Feeds
  module Parsers
    class RssParser < Feeds::BaseParser
      def parse(url)
        Feedjira::Feed.fetch_and_parse(url).entries.map do |entry|
          event_from_entry(entry)
        end
      end

      def event_from_entry(entry)
        event_metadata_hash(entry)
        Feeds::Event.new entry.to_h.merge(
          summary: Nokogiri::HTML(entry.summary).text,
          event_id: digest(entry.to_json)
        )
      end

      def event_metadata_hash(entry)
        doc = Nokogiri::HTML.parse open(entry.url)
        doc.css('br').each{ |br| br.replace(", ") }
        event_hash = {}
        event_dates = find_value_by_text(doc: doc, text: 'Event Date').split(' - ')
        time = find_value_by_text(doc: doc, text: 'Event Time').gsub('Central', '')&.split('-')
        event_hash[:url] = entry.url
        event_hash[:start_date] = event_dates.first
        event_hash[:start_time] = "#{time.first} Central".to_time
        event_hash[:end_time] = "#{time.last} Central".to_time
        puts "======================= Entry Data ====================="
        pp event_hash
        puts "======================= /end Entry URL ====================="
      end

      private

      # NOTE: this is what happens when you're scraping a webpage that uses no ids or classes or data attributes...
      def find_value_by_text doc: nil, text: nil
        if doc && text
          doc.xpath("//b[contains(text(), '#{text}:')]/.").first&.ancestors('td')&.first&.next&.text
        end
      end
    end
  end
end
