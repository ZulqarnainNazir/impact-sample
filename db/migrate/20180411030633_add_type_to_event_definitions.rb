class AddTypeToEventDefinitions < ActiveRecord::Migration
  def change
    add_column :event_definitions, :type, :string
  end
end
