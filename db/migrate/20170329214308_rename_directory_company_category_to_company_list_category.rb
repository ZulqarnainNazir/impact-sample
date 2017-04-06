class RenameDirectoryCompanyCategoryToCompanyListCategory < ActiveRecord::Migration
  def change
    rename_table :directory_company_categories, :company_list_categories
    rename_column :company_list_categories, :directory_widget_id, :company_list_id
  end
end
