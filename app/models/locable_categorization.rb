class LocableCategorization < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'categorizations'

  belongs_to :categorizable, polymorphic: true
  belongs_to :category, class_name: 'LocableCategory', foreign_key: :category_id
end
