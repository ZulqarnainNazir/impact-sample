class BusinessUpdateRequest < ActiveRecord::Base
  has_one :business_location_update_request
end
