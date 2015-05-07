class AddContentBlogSidebarToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :content_blog_sidebar, :boolean, default: true, null: false
  end
end
