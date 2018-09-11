module Feeds
  class BaseParser
    def parse(url)
      raise 'Not implemented'
    end

    def digest(string)
      Digest::SHA1.hexdigest string
    end

    def get_location(location_search)
      searches = Geocoder.search(location_search)
      search = searches.first

      return {} unless search.present?

      Feeds::Location.new({
        state: search.state_code,
        zip_code: search.postal_code,
        city: search.city,
        street1: search.street_address,
        name: search.neighborhood
      })
    end
  end
end
