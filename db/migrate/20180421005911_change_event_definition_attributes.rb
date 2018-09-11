class ChangeEventDefinitionAttributes < ActiveRecord::Migration
  def change
    remove_column :event_definitions, :imported_title, :text
    remove_column :event_definitions, :imported_start_date, :date
    add_column :event_definitions, :imported_event_id, :text
  end
end
