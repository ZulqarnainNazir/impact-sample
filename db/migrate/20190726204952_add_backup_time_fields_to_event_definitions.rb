class AddBackupTimeFieldsToEventDefinitions < ActiveRecord::Migration
  def up
    add_column :event_definitions, :legacy_start_time, :time
    add_column :event_definitions, :legacy_end_time, :time

    EventDefinition.update_all('legacy_start_time=start_time')
    EventDefinition.update_all('legacy_end_time=end_time')
  end

  def down
    remove_column :event_definitions, :legacy_start_time
    remove_column :event_definitions, :legacy_end_time
  end
end
