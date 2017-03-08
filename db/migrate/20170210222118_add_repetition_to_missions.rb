class AddRepetitionToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :repetition, :text
    add_column :mission_instances, :repetition, :text
  end
end
