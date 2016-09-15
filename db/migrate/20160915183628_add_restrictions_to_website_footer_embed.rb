class AddRestrictionsToWebsiteFooterEmbed < ActiveRecord::Migration
  def change
    add_column :websites, :hide_on_landing, :boolean
    add_column :websites, :hide_on_blog, :boolean
  end
end
