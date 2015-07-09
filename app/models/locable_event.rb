class LocableEvent < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'events'

  belongs_to :business, class_name: LocableBusiness.name, foreign_key: :business_id
end
