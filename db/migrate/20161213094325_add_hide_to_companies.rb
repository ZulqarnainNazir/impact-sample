class AddHideToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :hide, :boolean
  end
end
