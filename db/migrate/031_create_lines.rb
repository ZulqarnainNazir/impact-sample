class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.references :business, index: true, foreign_key: true
      t.text :type, null: false
      t.text :title, null: false
      t.text :description
      t.text :delivery_experience
      t.text :delivery_process
      t.text :uniqueness
      t.text :customer_description
      t.text :customer_problem
      t.text :customer_benefit
      t.timestamps null: false
    end
  end
end
