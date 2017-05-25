class AddArchivedToContactForms < ActiveRecord::Migration
  def change
    add_column :contact_forms, :archived, :boolean, default: false
  end
end
