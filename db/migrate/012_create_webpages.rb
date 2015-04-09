class CreateWebpages < ActiveRecord::Migration
  def change
    create_table :webpages do |t|
      t.references :website, index: true, null: false
      t.boolean :active, default: false, null: false
      t.string :type, null: false
      t.string :pathname, default: '', null: false
      t.string :name, null: false
      t.string :title, null: false
      t.string :description
      t.json :settings
      t.text :custom_css
    end

    add_index :webpages, [:website_id, :pathname], unique: true
  end
end
