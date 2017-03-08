class UpdateMissionsFields < ActiveRecord::Migration
  def change
    remove_column :missions, :business_id, :integer
    add_column :missions, :group, :string
    add_column :missions, :tier, :string
    add_column :missions, :difficulty, :string
    add_column :missions, :pillars, :jsonb
    add_column :missions, :success_tips, :text
    add_column :missions, :industry, :jsonb
    add_column :missions, :target_frequency_days, :integer
    add_column :missions, :alert_frequency_days, :integer
    add_column :missions, :settings, :jsonb
  end
end
