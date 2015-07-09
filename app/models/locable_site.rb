class LocableSite < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'sites'
end
