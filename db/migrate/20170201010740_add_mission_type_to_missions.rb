class AddMissionTypeToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :business_id, :integer
    add_index :missions, :business_id
  end
end
