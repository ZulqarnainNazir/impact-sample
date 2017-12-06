class CreateModules < ActiveRecord::Migration
  def change
    create_table :account_modules do |t|
    	t.integer :business_id
    	t.integer :kind
    	t.boolean :active
    	t.timestamps null: false
    end
  end
end