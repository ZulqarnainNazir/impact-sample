class AddLayoutToContactForms < ActiveRecord::Migration
  def change
    add_column :contact_forms, :layout, :string
  end
end
