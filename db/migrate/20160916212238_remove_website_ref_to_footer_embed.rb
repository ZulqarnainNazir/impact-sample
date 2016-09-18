class RemoveWebsiteRefToFooterEmbed < ActiveRecord::Migration
  def change
    remove_reference :footer_embeds, :website, index: true, foreign_key: true
  end
end
