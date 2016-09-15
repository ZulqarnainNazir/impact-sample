class AddRestrictionsToWebsiteFooterEmbed < ActiveRecord::Migration
  def change
<<<<<<< ea946d7e6dab96d4a564af6a77058724664d350a
<<<<<<< 9fd7e96272fac9e3251475084c01fb12ddf51620
    add_column :websites, :hide_on_landing, :boolean
    add_column :websites, :hide_on_blog, :boolean
=======
    add_column :websites, :embed_on_landing, :boolean
    add_column :websites, :embed_on_blog, :boolean
>>>>>>> footer embed options for blog posts and landing pages
=======
    add_column :websites, :hide_on_landing, :boolean
    add_column :websites, :hide_on_blog, :boolean
>>>>>>> fixed logic to hide footer embed: next - change website builder
  end
end
