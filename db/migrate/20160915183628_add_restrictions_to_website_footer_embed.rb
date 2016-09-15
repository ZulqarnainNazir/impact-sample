class AddRestrictionsToWebsiteFooterEmbed < ActiveRecord::Migration
  def change
<<<<<<< 9fd7e96272fac9e3251475084c01fb12ddf51620
    add_column :websites, :hide_on_landing, :boolean
    add_column :websites, :hide_on_blog, :boolean
=======
    add_column :websites, :embed_on_landing, :boolean
    add_column :websites, :embed_on_blog, :boolean
>>>>>>> footer embed options for blog posts and landing pages
  end
end
