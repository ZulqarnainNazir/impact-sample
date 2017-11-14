class AddEventsEmbed < ActiveRecord::Migration
  def change
  	add_column :event_definitions, :embed, :text
  end
end
