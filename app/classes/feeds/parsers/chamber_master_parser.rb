# encoding: utf-8
# Extends the base RSS parser for Chamber Master feeds
# Need to test for Folsom Chamber and El Dorada Chamber. May need to extract into sub or super class in future.
module Feeds
  module Parsers
    class ChamberMasterParser < Feeds::Parsers::RssParser
      def event_from_entry(entry, feed)
        parsed_title = Nickel.parse(entry.title)
        occurence    = parsed_title.occurrences[0]
        orig_title   = entry.title
        title        = parsed_title.message.sub(': ', '')
        start_date   = occurence.start_date.try(:to_date)
        end_date     = occurence.end_date.try(:to_date)

        description = Nokogiri::HTML(entry.summary).text
        desc_occurence = occurence_from_description(start_date, description)

        digest_key = "#{entry.url}_#{start_date}"

        Feeds::Event.new entry.to_h.merge(
          summary: description,
          event_id: digest(digest_key),
          title: title,
          start_date: start_date,
          end_date: end_date,
          start_time: parse_time(feed, desc_occurence&.start_time&.to_time, start_date),
          end_time: parse_time(feed, desc_occurence&.end_time&.to_time, end_date)
        )
      end

      private

      def occurence_from_description(start_date, description)
        return unless description.present?
        begin
          parsed_desc = Nickel.parse(description)
          parsed_desc.occurrences.find do |occurence|
            occurence.start_date.to_date == start_date
          end
        rescue
          Rails.logger.error "Failed to parse occurence from description. Start date: #{start_date}, Description: #{description}"

          nil
        end
      end
    end
  end
end
