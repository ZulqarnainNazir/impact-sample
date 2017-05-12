class RemoveFormFieldAndValueFromFormSubmissions < ActiveRecord::Migration
  def change
    remove_column :form_submissions, :form_field_id, :integer
    remove_column :form_submissions, :value, :string
    add_column :form_submissions, :business_id, :integer, index: true
  end
end
