class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :webpage, index: true, null: false
      t.text :type, null: false
      t.integer :position, default: 0, null: false
      t.integer :max_blocks
      t.timestamps null: false
    end
  end
end
