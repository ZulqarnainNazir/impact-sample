class RenameDirectoryCompanyToCompanyListCompany < ActiveRecord::Migration
  def change
    rename_table :directory_companies, :company_list_companies
    rename_column :company_list_companies, :directory_widget_id, :company_list_id
    rename_column :company_list_companies, :directory_company_category_id, :company_list_category_id
  end
end
