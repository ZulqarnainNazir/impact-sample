class ChangeDescriptionToContent < ActiveRecord::Migration
  def change
  	rename_column :quick_posts, :description, :content
  end
end
