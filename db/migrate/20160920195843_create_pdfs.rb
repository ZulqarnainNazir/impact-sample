class CreatePdfs < ActiveRecord::Migration
  def change
    create_table :pdfs do |t|
<<<<<<< e89d73c4a6c09dc7135b2adf290248839e135188
      t.attachment :attachment
=======
      t.string :file_name
      t.string :file_size
      t.string :attachment
>>>>>>> new migrations for pdf attachment field - form needs work
      t.references :user, index: true, foreign_key: true
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
