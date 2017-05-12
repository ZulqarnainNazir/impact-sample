class CreateContactFormFormFields < ActiveRecord::Migration
  def change
    create_table :contact_form_form_fields do |t|
      t.string :label
      t.integer :position
      t.references :contact_form, index: true, foreign_key: true
      t.references :form_field, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
