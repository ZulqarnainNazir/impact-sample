class AddPublishedTimeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :published_time, :datetime

  end
end
