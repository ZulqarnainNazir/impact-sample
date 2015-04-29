class AddCachedStylesToImages < ActiveRecord::Migration
  def change
    add_column :images, :cached_styles, :text, array: true
  end
end
