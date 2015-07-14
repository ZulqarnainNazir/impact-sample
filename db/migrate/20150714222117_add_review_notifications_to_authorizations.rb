class AddReviewNotificationsToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :review_notifications, :boolean, default: true, null: false
  end
end
