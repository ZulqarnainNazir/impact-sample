class AddProductKindsToMercantileEmbed < ActiveRecord::Migration
  def change
    add_column :mercantile_embeds, :product_kinds, :text, array: true
  end
end
