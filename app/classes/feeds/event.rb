module Feeds
  class Event < OpenStruct
    def location_data_present?
      return false unless location

      location.try(:street1) ||
        location.try(:street2) ||
        location.try(:city) ||
        location.try(:state) ||
        location.try(:zip_code)
    end
  end
end
