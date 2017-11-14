class ChangeColumnNameInCategorizations < ActiveRecord::Migration
  def change
    if index_exists? :categorizations, [:business_id]
      remove_index :categorizations, column: [:business_id]
    end

    rename_column :categorizations, :business_id, :categorizable_id
    add_column :categorizations, :categorizable_type, :string
    add_index :categorizations, [:categorizable_id, :categorizable_type], name: 'index_categories_on_poly_id_and_poly_type'

    Categorization.update_all(categorizable_type: 'Business')
  end
end
