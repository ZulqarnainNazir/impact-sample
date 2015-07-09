class LocableCategory < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'categories'
  self.inheritance_column = '_not_there_'
end
