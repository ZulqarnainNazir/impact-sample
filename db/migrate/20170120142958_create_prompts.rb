class CreatePrompts < ActiveRecord::Migration
  def change
    create_table :prompts do |t|
      t.integer :business_id
      t.integer :assigned_user_id
      t.integer :creating_user_id
      t.integer :to_do_list_id
      t.datetime :deactivated_at
      t.datetime :activated_at
      t.datetime :last_completed_at
      t.datetime :next_due_at
      t.integer :status, default: 0
      t.integer :prompt_type, default: 0
      t.text :description
      t.text :benefits
      t.string :time_to_complete

      t.timestamps null: false
    end

    add_index :prompts, :business_id
    add_index :prompts, :assigned_user_id
    add_index :prompts, :creating_user_id
    add_index :prompts, :to_do_list_id
  end
end
