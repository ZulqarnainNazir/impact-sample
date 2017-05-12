class AddEmbedFieldsToContactForms < ActiveRecord::Migration
  def change
    add_column :contact_forms, :uuid, :string
    add_reference :contact_forms, :company_list, index: true
    add_column :contact_forms, :public_label, :string
  end
end
