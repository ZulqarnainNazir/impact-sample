class CreateQuickPosts < ActiveRecord::Migration
  def change
    create_table :quick_posts do |t|
      t.references :business, index: true, foreign_key: true
      t.text :title
      t.text :content

      t.timestamps null: false
    end
  end
end
