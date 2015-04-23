class DropProjectsTables < ActiveRecord::Migration
  def change
    drop_table :project_images
    drop_table :projects
  end
end
