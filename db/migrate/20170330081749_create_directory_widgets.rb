class CreateDirectoryWidgets < ActiveRecord::Migration
  def change
    create_table :directory_widgets, :force => true do |t|
      t.string :name
      t.references :business, index: true
      t.references :company_list, index: true
      t.string :background_color
      t.string :uuid

      t.timestamps null: false
    end
  end
end
