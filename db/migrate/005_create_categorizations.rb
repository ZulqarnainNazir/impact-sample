class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.references :business, index: true, null: false
      t.references :category, index: true, null: false
      t.timestamps null: false
    end
  end
end
