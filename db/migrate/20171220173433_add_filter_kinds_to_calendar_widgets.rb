class AddFilterKindsToCalendarWidgets < ActiveRecord::Migration
  def change
    add_column :calendar_widgets, :filter_kinds, :integer, array: true, default: []
  end
end
