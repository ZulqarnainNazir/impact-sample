class AddSearchToMercantileEmbed < ActiveRecord::Migration
  def change
    add_column :mercantile_embeds, :enable_search, :boolean, null: false, default: false
  end
end
