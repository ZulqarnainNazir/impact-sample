class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :business, index: true, null: false
      t.references :user, index: true, null: false
      t.integer :role, null: false
      t.timestamps null: false
    end
  end
end
