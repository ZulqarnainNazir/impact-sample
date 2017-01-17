class RemoveCachedStylesFromImage < ActiveRecord::Migration
  def change
    remove_column :images, :cached_styles
  end
end
