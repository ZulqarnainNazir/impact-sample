class CreateWebhosts < ActiveRecord::Migration
  def change
    create_table :webhosts do |t|
      t.references :website, index: true, null: false
      t.string :name, null: false
      t.boolean :primary, default: false, null: false
      t.json :settings
      t.timestamps null: false
    end

    add_index :webhosts, :name, unique: true
  end
end
