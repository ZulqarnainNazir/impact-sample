class CreateLineImages < ActiveRecord::Migration
  def change
    create_table :line_images do |t|
      t.references :line, index: true, null: false
      t.integer :position, default: 0, null: 0
      t.timestamps null: false
    end
  end
end
