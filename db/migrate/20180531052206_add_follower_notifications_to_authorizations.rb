class AddFollowerNotificationsToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :follower_notifications, :string, null: false, default: "never"
  end
end
