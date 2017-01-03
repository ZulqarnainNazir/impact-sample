class AddReadByToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :read_by, :integer, array: true, default: [], null: false
  end
end
