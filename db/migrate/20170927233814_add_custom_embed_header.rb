class AddCustomEmbedHeader < ActiveRecord::Migration
  def change
  	add_column :websites, :header_embed, :text
  	add_column :websites, :hide_header_embed_on_landing, :boolean
  	add_column :websites, :hide_header_embed_on_blog, :boolean
  end
end