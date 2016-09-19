class RemoveRestrictionsFromWebsiteFooterEmbed < ActiveRecord::Migration
  def change
    remove_column :websites, :hide_on_landing, :boolean
    remove_column :websites, :hide_on_blog, :boolean
  end
end
