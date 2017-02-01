class CreateReviewWidgets < ActiveRecord::Migration
  def change
    create_table :review_widgets do |t|
      t.string :uuid
      t.string :name
      t.text :description
      t.text :settings
      t.references :business, index: true, foreign_key: true
      t.string :layout


      t.timestamps null: false
    end
  end
end
