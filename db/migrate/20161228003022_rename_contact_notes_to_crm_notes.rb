class RenameContactNotesToCrmNotes < ActiveRecord::Migration
  def change
    rename_table :contact_notes, :crm_notes if table_exists? :contact_notes
  end
end
