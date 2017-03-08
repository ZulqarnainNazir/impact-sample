class AddTrackableToMissionHistories < ActiveRecord::Migration
  def change
    add_column :mission_histories, :trackable_type, :string
    add_column :mission_histories, :trackable_id, :integer
    add_index :mission_histories, :trackable_type
    add_index :mission_histories, :trackable_id
  end
end
