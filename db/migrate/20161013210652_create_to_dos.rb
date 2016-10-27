class CreateToDos < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.integer :business_id
      t.text :title
      t.text :description
      t.integer :submission_status, default: 0
      t.integer :status, default: 0
      t.datetime :due_date

      t.timestamps null: false
    end

    add_index :to_dos, :business_id
  end
end
