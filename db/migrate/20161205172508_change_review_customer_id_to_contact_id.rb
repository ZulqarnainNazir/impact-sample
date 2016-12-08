class ChangeReviewCustomerIdToContactId < ActiveRecord::Migration
  def change
    rename_column :reviews, :customer_id, :contact_id
    rename_column :contact_messages, :customer_id, :contact_id
  end
end
