class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :business, index: true, null: false
      t.references :customer, index: true, null: false
      t.text :token, null: false
      t.datetime :completed_at
      t.date :serviced_at
      t.integer :score
      t.text :description
      t.timestamps null: false
    end
  end
end
