class CreateCompanyLists < ActiveRecord::Migration
  def change
    create_table :company_lists do |t|
      t.string :name
      t.integer :sort_by
      t.references :business, index: true
    end
  end
end
