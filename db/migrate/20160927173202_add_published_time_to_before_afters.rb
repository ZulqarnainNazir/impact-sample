class AddPublishedTimeToBeforeAfters < ActiveRecord::Migration
  def change
    add_column :before_afters, :published_time, :datetime
  end
end
