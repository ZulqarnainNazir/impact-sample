class AddPublishedOnToContentPosts < ActiveRecord::Migration
  def change
    add_column :before_afters, :published_on, :date
    add_column :galleries, :published_on, :date
    add_column :offers, :published_on, :date
    add_column :quick_posts, :published_on, :date
  end
end
