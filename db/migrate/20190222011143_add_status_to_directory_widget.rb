class AddStatusToDirectoryWidget < ActiveRecord::Migration
  def change
    add_column :directory_widgets, :status, :bool
  end
end
