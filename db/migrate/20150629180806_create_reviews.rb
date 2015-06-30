class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :business, index: true, null: false
      t.text :external_id, null: false
      t.text :external_name, null: false
      t.text :external_type, null: false
      t.text :external_url, null: false
      t.text :external_user_id, null: false
      t.text :external_user_name, null: false
      t.text :title, null: false
      t.text :description, null: false
      t.decimal :rating, precision: 2, scale: 1, null: false
      t.datetime :reviewed_at, null: false
      t.timestamps null: false
    end
  end
end
