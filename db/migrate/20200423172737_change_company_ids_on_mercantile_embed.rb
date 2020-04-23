class ChangeCompanyIdsOnMercantileEmbed < ActiveRecord::Migration
  def up
    add_column :mercantile_embeds, :company_list_id, :integer
    remove_column :mercantile_embeds, :company_list_ids
  end

  def down
    add_column :mercantile_embeds, :company_list_ids, text, array: true, default: []
    remove_column :mercantile_embeds, :company_list_id
  end
end
