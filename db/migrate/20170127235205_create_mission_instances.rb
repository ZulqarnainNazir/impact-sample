class CreateMissionInstances < ActiveRecord::Migration
  def change
    create_table :mission_instances do |t|
      t.integer :business_id
      t.integer :status
      t.integer :mission_id

      t.timestamps null: false
    end

    add_index :mission_instances, :business_id
    add_index :mission_instances, :mission_id
  end
end
