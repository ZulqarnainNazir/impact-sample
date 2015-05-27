class AddWebpathToNavLinks < ActiveRecord::Migration
  def change
    add_column :nav_links, :webpath, :text
  end
end
