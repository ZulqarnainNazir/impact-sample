class AddStatusToCalendarWidget < ActiveRecord::Migration
  def change
    add_column :calendar_widgets, :status, :bool
  end
end
