class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :business, index: true, null: false
      t.text :title, null: false
      t.text :description
      t.timestamps null: false
    end
  end
end
