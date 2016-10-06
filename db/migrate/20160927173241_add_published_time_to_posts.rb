class AddPublishedTimeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :published_time, :time
  end
end
