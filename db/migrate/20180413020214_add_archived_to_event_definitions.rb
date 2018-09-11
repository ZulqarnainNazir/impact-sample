class AddArchivedToEventDefinitions < ActiveRecord::Migration
  def change
    add_column :event_definitions, :archived, :boolean, default: false
  end
end
