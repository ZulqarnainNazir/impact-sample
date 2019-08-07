class AddTimeZoneToEventDefinitions < ActiveRecord::Migration
  def change
    add_column :event_definitions, :time_zone, :string
  end
end
