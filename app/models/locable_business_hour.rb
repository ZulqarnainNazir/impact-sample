class LocableBusinessHour < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'business_hours'

  belongs_to :business, class_name: LocableBusiness.name
end
