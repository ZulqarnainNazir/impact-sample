class ChangePomptsToMissions < ActiveRecord::Migration
  def change
    rename_table :prompts, :missions
  end
end
