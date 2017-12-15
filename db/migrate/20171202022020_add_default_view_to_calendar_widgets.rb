class AddDefaultViewToCalendarWidgets < ActiveRecord::Migration
  def change
    add_column :calendar_widgets, :default_view, :string
  end
end
