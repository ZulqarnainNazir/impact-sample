class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.references :frame, polymorphic: true, index: true, null: false
      t.references :link, polymorphic: true, index: true
      t.string :type, null: false
      t.string :theme
      t.string :style
      t.string :link_label
      t.text :heading
      t.text :subheading
      t.text :text
      t.text :link_external_url
      t.boolean :link_target_blank, default: false, null: false
      t.boolean :link_no_follow, default: false, null: false
      t.integer :link_version, default: 0, null: false
      t.timestamps null: false
    end
  end
end
