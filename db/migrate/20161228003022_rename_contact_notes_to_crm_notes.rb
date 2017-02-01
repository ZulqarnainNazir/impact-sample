class RenameContactNotesToCrmNotes < ActiveRecord::Migration
  def change
    rename_table :contact_notes, :crm_notes
  end
end
