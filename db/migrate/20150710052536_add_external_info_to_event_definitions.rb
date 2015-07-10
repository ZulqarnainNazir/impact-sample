class AddExternalInfoToEventDefinitions < ActiveRecord::Migration
  def change
    add_column :event_definitions, :external_type, :text
    add_column :event_definitions, :external_id, :text
  end
end
