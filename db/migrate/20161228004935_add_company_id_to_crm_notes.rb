class AddCompanyIdToCrmNotes < ActiveRecord::Migration
  def change
    add_reference :crm_notes, :company, index: true
  end
end
