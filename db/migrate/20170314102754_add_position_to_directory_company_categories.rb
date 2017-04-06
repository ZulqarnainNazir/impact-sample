class AddPositionToDirectoryCompanyCategories < ActiveRecord::Migration
  def change
    add_column :directory_company_categories, :position, :integer
  end
end
