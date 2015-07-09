class LocableRolesUser < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'roles_users'
end

