class RemoveTypesAddKinds < ActiveRecord::Migration
  def change
    remove_column :event_definitions, :is_event, :boolean, default: true
    remove_column :event_definitions, :is_aclass, :boolean, default: false
    remove_column :event_definitions, :is_deadline, :boolean, default: false
    add_column :event_definitions, :kind, :integer, default: 0, null: false
  end
end