class AddFooterEmbedToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :footer_embed, :text
  end
end
