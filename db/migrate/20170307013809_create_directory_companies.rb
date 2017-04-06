class CreateDirectoryCompanies < ActiveRecord::Migration
  def change
    create_table :directory_companies do |t|
      t.references :directory_widget
      t.references :directory_company_category
      t.references :company

      t.timestamps null: false
    end
  end
end
