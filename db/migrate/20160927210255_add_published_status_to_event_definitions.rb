class AddPublishedStatusToEventDefinitions < ActiveRecord::Migration
  def change
    add_column :event_definitions, :published_status, :boolean
  end
end
