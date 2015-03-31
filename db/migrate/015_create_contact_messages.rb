class CreateContactMessages < ActiveRecord::Migration
  def change
    create_table :contact_messages do |t|
      t.references :business, index: true, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.text :message, null: false
      t.timestamps null: false
    end
  end
end
