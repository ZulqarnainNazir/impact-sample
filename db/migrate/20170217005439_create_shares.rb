class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
        t.text :message
        t.references :shareable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
