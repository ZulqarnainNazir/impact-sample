class AddRequiredColumnToFormFields < ActiveRecord::Migration
  def change
    add_column :form_fields, :required, :boolean, :default => false
    FormField.find_by(:name => 'first_name').update(:required => "t")
    FormField.find_by(:name => 'last_name').update(:required => "t")
    FormField.find_by(:name => 'email').update(:required => "t")
    FormField.find_by(:name => 'message').update(:required => "t")
  end
end
