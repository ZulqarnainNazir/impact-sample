class AddStatusToMissionInstanceEvents < ActiveRecord::Migration
  def change
    add_column :mission_instance_events, :status, :integer, default: 0
  end
end
