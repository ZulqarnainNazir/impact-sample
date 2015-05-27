class AddEventsSidebarToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :events_sidebar, :boolean, default: true, null: false
  end
end
