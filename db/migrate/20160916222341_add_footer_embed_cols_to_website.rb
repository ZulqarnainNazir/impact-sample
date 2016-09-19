class AddFooterEmbedColsToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :hide_embed_on_landing, :boolean
    add_column :websites, :hide_embed_on_blog, :boolean
  end
end
