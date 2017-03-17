class RenameQuickPostContentToQuickPostDescription < ActiveRecord::Migration
  def change
  	rename_column :quick_posts, :content, :description
  end
end
