module Feeds
  class BaseParser
    def parse(feed)
      raise 'Not implemented'
    end

    def digest(string)
      Digest::SHA1.hexdigest string
    end

    def get_location(location_search)
      searches = MultiGeocoderService.search(location_search)
      # search = searches.first
      search = searches
      return {} unless search.present?

      Feeds::Location.new({
        street1: search.address,
        city: search.city,
        state: search.state_code,
        zip_code: search.postal_code,
        name: search.name
      })
    end

    def parse_time(feed, timestamp, date = nil)
      return unless timestamp.present?

      before_zone = Time.zone
      Time.zone = feed.time_zone

      if date
        parsed_time = Time.zone.parse(timestamp.to_s)
        parsed_date = DateTime.parse(date.to_s)
        DateTime.new(
          parsed_date.year,
          parsed_date.month,
          parsed_date.day,
          parsed_time.hour,
          parsed_time.min,
          parsed_time.sec,
          parsed_date.in_time_zone(Time.zone).formatted_offset
        )
      else
        Time.zone.parse(timestamp.to_s)
      end
    ensure
      Time.zone = before_zone
    end
  end
end
