class AddSuperUser < ActiveRecord::Migration
  def change
    add_column :users, :super_user, :boolean, default: false, null: false
  end
end
