class RemoveNullContraintFromPathname < ActiveRecord::Migration
  def change
    change_column :webpages, :pathname, :string, null: true
  end
end
