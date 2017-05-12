class AddRequiredToContactFormFormFields < ActiveRecord::Migration
  def change
    add_column :contact_form_form_fields, :required, :boolean, :default => false
  end
end
