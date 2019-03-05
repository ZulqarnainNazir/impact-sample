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
        street1: "#{search.house_number} #{search.street}",
        city: search.city,
        state: search.state_code,
        zip_code: search.postal_code,
        name: search.neighbourhood
      })
    end
  end
end
