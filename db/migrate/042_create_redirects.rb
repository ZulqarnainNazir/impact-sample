class CreateRedirects < ActiveRecord::Migration
  def change
    create_table :redirects do |t|
      t.references :website, index: true, null: false
      t.text :from_path, null: false
      t.text :to_path, null: false
      t.timestamps null: false
    end
  end
end
