class MoveUserFieldsToMissionInstances < ActiveRecord::Migration
  def change
    remove_column :missions, :assigned_user_id, :integer
    remove_column :missions, :creating_user_id, :integer

    add_column :mission_instances, :assigned_user_id, :integer
    add_column :mission_instances, :creating_user_id, :integer

    add_index :mission_instances, :assigned_user_id
    add_index :mission_instances, :creating_user_id
  end
end
