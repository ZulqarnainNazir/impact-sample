class RenameCustomerNoteToContactNote < ActiveRecord::Migration
  def change
    rename_table :customer_notes, :contact_notes
    rename_column :contact_notes, :customer_id, :contact_id
    rename_column :feedbacks, :customer_id, :contact_id
  end
end
