class UpdateWebsiteSidebarSettings < ActiveRecord::Migration
  def change
    add_column :websites, :content_blog_sidebar_on_reviews, :boolean, default: true, null: false
  end
end
