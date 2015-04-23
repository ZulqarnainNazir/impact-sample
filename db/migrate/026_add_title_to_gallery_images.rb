class AddTitleToGalleryImages < ActiveRecord::Migration
  def change
    add_column :gallery_images, :title, :text
  end
end
