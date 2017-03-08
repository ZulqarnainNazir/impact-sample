class AddStartTimeAndEndTimeToMissionInstancesAndMissionInstanceEvents < ActiveRecord::Migration
  def change
    add_column :mission_instances, :start_time, :time
    add_column :mission_instances, :end_time, :time
  end
end
