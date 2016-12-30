class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.references :user_business
      t.references :company_business
      t.text :private_details
      t.timestamps null: false
    end
  end
end
