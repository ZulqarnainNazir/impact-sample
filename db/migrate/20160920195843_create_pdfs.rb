class CreatePdfs < ActiveRecord::Migration
  def change
    create_table :pdfs do |t|
      t.attachment :attachment
      t.references :user, index: true, foreign_key: true
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
