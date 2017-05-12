class AddDefaultColumnToFormFields < ActiveRecord::Migration
  def change
    add_column :form_fields, :default, :boolean, :default => false
    FormField.find_by(:name => 'first_name').update(:default => true)
    FormField.find_by(:name => 'last_name').update(:default => true)
    FormField.find_by(:name => 'email').update(:default => true)
    FormField.find_by(:name => 'phone').update(:default => true)
    FormField.find_by(:name => 'message').update(:default => true)
  end
end
