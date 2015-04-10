class AddMenusToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :header_menu, :json
    add_column :websites, :footer_menu, :json
  end
end
