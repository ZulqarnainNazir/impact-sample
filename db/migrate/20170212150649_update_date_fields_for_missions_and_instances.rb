class UpdateDateFieldsForMissionsAndInstances < ActiveRecord::Migration
  def change
    remove_column :missions, :next_due_at, :datetime
    remove_column :missions, :activated_at, :datetime
    remove_column :missions, :deactivated_at, :datetime

    remove_column :mission_instances, :next_due_at, :datetime

    add_column :mission_instances, :start_date, :date
    add_column :mission_instances, :end_date, :date
  end
end
