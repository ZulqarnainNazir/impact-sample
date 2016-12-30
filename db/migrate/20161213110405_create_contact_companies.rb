class CreateContactCompanies < ActiveRecord::Migration
  def change
    create_table :contact_companies do |t|
      t.references :contact, index: true
      t.references :company, index: true

      t.timestamps null: false
    end
  end
end
