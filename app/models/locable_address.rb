class LocableAddress < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'addresses'

  def to_s
    sprintf("%s %s %s, %s %s", street1, street2, city, state, postal)
  end
end
