# encoding: utf-8
# Extends the base Chambernation parser for Webster City Chamber
module Feeds
  module Parsers
    class ChamberNationWebsterCityParser < Feeds::Parsers::RssParser
      def event_from_entry(event)
        event_metadata = event_metadata_hash(event)
        parsed_title   = Nickel.parse(event.title.gsub(/Weekly|Daily|Monthly/, ''))
        occurence      = parsed_title.occurrences[0]
        orig_title     = event.title
        title          = parsed_title.message.sub(': ', '')

        description = Nokogiri::HTML(event.summary).text

        digest_key = "#{event.url}_#{event_metadata.dig(:start_date)}"

        Feeds::Event.new event.to_h.merge(
          summary: description,
          event_id: digest(digest_key),
          title: title,
          start_date: event_metadata.dig(:start_date),
          start_time: event_metadata.dig(:start_time),
          end_date:  event_metadata.dig(:end_date),
          end_time: event_metadata.dig(:end_time),
          url: event_metadata.dig(:url),
          location: get_location(event_metadata.dig(:google_maps_url), event_metadata.dig(:location_name))
        )
      end

      private

      def get_location google_maps_url, location_name
        address1, city, state_zip_country = CGI::parse(google_maps_url).to_a.flatten.last.split(',') rescue ''
        state_id, zip_code, country_id = state_zip_country&.split(' ')
        if country_id
          Feeds::Location.new({
            state: state_id,
            zip_code: zip_code,
            city: city,
            street1: address1,
            name: location_name
          })
        end
      end

      # start_date, start_time, end_date, end_time
      def event_metadata_hash(event)
        doc = Nokogiri::HTML.parse open(event.url)
        doc.css('br').each{ |br| br.replace(", ") }
        event_hash = {}
        event_dates = find_value_by_text(doc: doc, text: 'Event Date').split(' - ')
        time = find_value_by_text(doc: doc, text: 'Event Time')&.gsub('Central', '')&.split('-')
        event_hash[:url] = event.url
        event_hash[:start_date] = Date.strptime(event_dates.first,'%m/%d/%Y')
        event_hash[:end_date] = Date.strptime(event_dates.last,'%m/%d/%Y')
        event_hash[:location_name] = find_value_by_text(doc: doc, text: 'Location')&.split(',')&.first
        event_hash[:google_maps_url] = doc.css('a').map { |link| link['href'] if link['href'].include?('maps.google') }.compact.first
        if time
          event_hash[:start_time] = "#{time.first}".to_time
          event_hash[:end_time] = "#{time.last}".to_time
        end

        event_hash
      end

      # NOTE: this is what happens when you're scraping a webpage that uses no ids or classes or data attributes...
      def find_value_by_text doc: nil, text: nil
        if doc && text
          doc.xpath("//b[contains(text(), '#{text}:')]/.").first&.ancestors('td')&.first&.next&.text
        end
      end
    end
  end
end
