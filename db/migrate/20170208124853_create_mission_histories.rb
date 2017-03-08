class CreateMissionHistories < ActiveRecord::Migration
  def change
    create_table :mission_histories do |t|
      t.integer :actor_id
      t.string :action
      t.text :description
      t.datetime :happened_at
      t.integer :mission_instance_id

      t.timestamps null: false
    end

    add_index :mission_histories, :actor_id
    add_index :mission_histories, :mission_instance_id
  end
end
