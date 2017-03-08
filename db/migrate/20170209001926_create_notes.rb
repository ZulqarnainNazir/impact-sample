class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note

      t.string :notable_type
      t.integer :notable_id

      t.integer :author_id

      t.timestamps null: false
    end

    add_index :notes, :notable_type
    add_index :notes, :notable_id
    add_index :notes, :author_id
  end
end
