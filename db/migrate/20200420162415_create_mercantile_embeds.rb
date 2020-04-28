class CreateMercantileEmbeds < ActiveRecord::Migration
  def change
    create_table :mercantile_embeds do |t|
      t.string :name
      t.string :public_label
      t.string :uuid
      t.references :business, index: true, foreign_key: true
      t.boolean :show_our_content
      t.text :company_list_ids, array: true, default: []
      t.integer :max_items
      t.integer :link_version
      t.integer :link_id
      t.string :link_external_url
      t.string :link_label
      t.boolean :link_target_blank
      t.boolean :link_no_follow

      t.timestamps null: false
    end
  end
end
