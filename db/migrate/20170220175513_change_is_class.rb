class ChangeIsClass < ActiveRecord::Migration
  def change
    rename_column :event_definitions, :is_class, :is_aclass
  end
end
