class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :website, index: true, null: false
      t.boolean :active, default: false, null: false
      t.string :type, null: false
      t.string :pathname, null: false
      t.string :title, null: false
      t.string :description
      t.json :settings
      t.timestamps null: false
    end

    add_index :pages, [:website_id, :pathname], unique: true
  end
end
