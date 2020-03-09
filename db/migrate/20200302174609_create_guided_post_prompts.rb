class CreateGuidedPostPrompts < ActiveRecord::Migration
  def change
    create_table :guided_post_prompts do |t|
      t.text :prompt
      t.text :description
      t.integer :post_type, index: true
      t.integer :section_type, index: true
      t.integer :industry, index: true

      t.timestamps null: false
    end
  end
end
