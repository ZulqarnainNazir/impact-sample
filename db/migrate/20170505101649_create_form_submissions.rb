class CreateFormSubmissions < ActiveRecord::Migration
  def change
    create_table :form_submissions do |t|
      t.references :contact_form, index: true, foreign_key: true
      t.references :form_field, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true
      t.string :value

      t.timestamps null: false
    end
  end
end
