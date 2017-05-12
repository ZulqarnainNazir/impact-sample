class CreateContactFormWidgets < ActiveRecord::Migration
  def change
    create_table :contact_form_widgets do |t|
      t.string :name
      t.references :business, index: true, foreign_key: true
      t.references :contact_form, index: true, foreign_key: true
      t.string :uuid
      t.string :public_label

      t.timestamps null: false
    end
  end
end
