class ChangeDescriptionToContent < ActiveRecord::Migration
  def change
  	rename_column(:quick_posts, :description, :content) unless QuickPost.column_names.include?('content')
  end
end
