class RemoveNotNullConstraintForContactIdOnCrmNotes < ActiveRecord::Migration
  def up
    change_column :crm_notes, :contact_id, :integer, :null => true
  end
  def down
    change_column :crm_notes, :contact_id, :integer, :null => false
  end
end
