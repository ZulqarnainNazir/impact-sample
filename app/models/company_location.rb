class CompanyLocation < ActiveRecord::Base
  include MultiGeocodable

  belongs_to :company
end
