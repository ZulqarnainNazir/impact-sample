class AddActivatedAtToMissionInstances < ActiveRecord::Migration
  def change
    add_column :mission_instances, :activated_at, :datetime
  end
end
