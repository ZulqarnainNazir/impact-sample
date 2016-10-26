class CreateToDoComments < ActiveRecord::Migration
  def change
    create_table :to_do_comments do |t|
      t.integer :commenter_id
      t.integer :to_do_id
      t.text :content

      t.timestamps null: false
    end

    add_index :to_do_comments, :commenter_id
    add_index :to_do_comments, :to_do_id
  end
end
