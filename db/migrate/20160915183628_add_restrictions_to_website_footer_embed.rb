class AddRestrictionsToWebsiteFooterEmbed < ActiveRecord::Migration
  def change
    add_column :websites, :embed_on_landing, :boolean
    add_column :websites, :embed_on_blog, :boolean
  end
end
