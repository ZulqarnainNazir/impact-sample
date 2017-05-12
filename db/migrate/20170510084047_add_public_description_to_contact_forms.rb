class AddPublicDescriptionToContactForms < ActiveRecord::Migration
  def change
    add_column :contact_forms, :public_description, :string
  end
end
