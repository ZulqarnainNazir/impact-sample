class CreateCalendarWidgets < ActiveRecord::Migration
  def change
    create_table :calendar_widgets do |t|
      t.string :name
      t.string :public_label
      t.string :uuid
      t.references :business, index: true
      t.integer :max_items
      t.boolean :enable_search
      t.text :company_list_ids, array:true, default: []
      t.boolean :show_our_content

      t.timestamps null: false
    end
  end
end
