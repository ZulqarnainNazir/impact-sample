class LocableResourcePlacement < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'resource_placements'

  belongs_to :placer, polymorphic: true
  belongs_to :resource, class_name: LocableResource.name, foreign_key: :resource_id
end
