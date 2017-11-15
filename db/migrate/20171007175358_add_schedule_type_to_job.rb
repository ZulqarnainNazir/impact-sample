class AddScheduleTypeToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :schedule_type, :int, { default: 0, null: false } 
  end
end
