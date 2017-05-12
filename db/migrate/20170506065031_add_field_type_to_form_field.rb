class AddFieldTypeToFormField < ActiveRecord::Migration
  def change
    add_column :form_fields, :field_type, :string
    FormField.all.each do |field|
      field.update(:field_type => "text")
    end
    FormField.find_by(:name => 'message').update(:field_type => "textarea")
  end
end
