class AddPublishedTimeToQuickPosts < ActiveRecord::Migration
  def change
    add_column :quick_posts, :published_time, :datetime
  end
end
