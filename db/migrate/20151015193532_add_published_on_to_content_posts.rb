class AddPublishedOnToContentPosts < ActiveRecord::Migration
  def change
    add_column :before_afters, :published_on, :datetime
    add_column :galleries, :published_on, :datetime
    add_column :offers, :published_on, :datetime
    add_column :quick_posts, :published_on, :datetime
  end
end
