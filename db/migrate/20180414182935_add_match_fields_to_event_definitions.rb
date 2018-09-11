class AddMatchFieldsToEventDefinitions < ActiveRecord::Migration
  def change
    add_column :event_definitions, :imported_title, :text
    add_column :event_definitions, :imported_start_date, :date
  end
end
