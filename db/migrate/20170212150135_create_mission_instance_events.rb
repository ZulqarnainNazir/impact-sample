class CreateMissionInstanceEvents < ActiveRecord::Migration
  def change
    create_table :mission_instance_events do |t|
      t.integer :business_id
      t.integer :mission_instance_id
      t.date :occurs_on

      t.timestamps null: false
    end

    add_index :mission_instance_events, :business_id
    add_index :mission_instance_events, :mission_instance_id
  end
end
