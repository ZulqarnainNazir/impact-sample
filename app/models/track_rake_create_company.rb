class TrackRakeCreateCompany < ActiveRecord::Base
  belongs_to :company
  belongs_to :company_location
  belongs_to :business
  belongs_to :location
  belongs_to :contact_company
end
