class AddPublishedStatusToQuickPosts < ActiveRecord::Migration
  def change
    add_column :quick_posts, :published_status, :boolean
  end
end
