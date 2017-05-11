class AddInviteAsMemberToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :invite_as_member, :boolean, default: false
  end
end
