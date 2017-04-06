class CreateDirectoryCompanyCategories < ActiveRecord::Migration
  def change
    create_table :directory_company_categories do |t|
      t.references :directory_widget
      t.string :label

      t.timestamps null: false
    end
  end
end
