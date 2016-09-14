class AddWebsiteRefToFooterEmbed < ActiveRecord::Migration
  def change
    add_reference :footer_embeds, :website, index: true, foreign_key: true
  end
end
