class AddAttributesToMissionInstances < ActiveRecord::Migration
  def change
    remove_column :missions, :last_completed_at, :datetime

    add_column :mission_instances, :last_completed_at, :datetime
    add_column :mission_instances, :last_snoozed_at, :datetime
    add_column :mission_instances, :last_skipped_at, :datetime

    add_column :mission_instances, :next_due_at, :datetime
    add_column :mission_instances, :last_status, :integer, default: 0

    add_column :mission_instances, :completion_times, :integer, default: 0
    add_column :mission_instances, :incompletion_times, :integer, default: 0
    add_column :mission_instances, :total_times, :integer, default: 0
  end
end
