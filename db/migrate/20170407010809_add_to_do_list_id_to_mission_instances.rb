class AddToDoListIdToMissionInstances < ActiveRecord::Migration
  def change
    add_column :mission_instances, :to_do_list_id, :integer
    add_column :mission_instances, :excluded_from_list, :boolean
    add_index :mission_instances, :to_do_list_id
  end
end
