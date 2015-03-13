class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :pathname, null: false
      t.timestamps null: false
    end

    add_index :categories, :pathname
  end
end
