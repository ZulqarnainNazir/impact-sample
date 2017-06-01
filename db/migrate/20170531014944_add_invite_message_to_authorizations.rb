class AddInviteMessageToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :invite_message, :string
  end
end
