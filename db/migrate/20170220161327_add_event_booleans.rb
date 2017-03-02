class AddEventBooleans < ActiveRecord::Migration
  def change
    add_column :event_definitions, :is_event, :boolean, default: true
    add_column :event_definitions, :is_class, :boolean, default: false
    add_column :event_definitions, :is_deadline, :boolean, default: false
    add_column :event_definitions, :hide_full_address, :boolean, default: false
    add_column :event_definitions, :show_city_only, :boolean, default: false
    add_column :event_definitions, :private, :boolean, default: false
    add_column :event_definitions, :virtual_event, :boolean, default: false
    add_column :event_definitions, :rsvp_required, :boolean, default: false
  end
end
