class CreateToDoLists < ActiveRecord::Migration
  def change
    create_table :to_do_lists do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
