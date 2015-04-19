class CreateProjectImages < ActiveRecord::Migration
  def change
    create_table :project_images do |t|
      t.references :project, index: true, null: false
      t.text :description
      t.integer :position, default: 0, null: 0
      t.timestamps null: false
    end
  end
end
