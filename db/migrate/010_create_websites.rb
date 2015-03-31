class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.references :business, index: true, null: false
      t.string :subdomain, null: false
      t.text :custom_css
      t.timestamps null: false
    end

    add_index :websites, :subdomain, unique: true
  end
end
