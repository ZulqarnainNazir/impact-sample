class AddInvitedAdminFlagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :added_to_account, :boolean, :default => false
    add_column :users, :invited_to_account, :boolean, :default => false
  end
end
