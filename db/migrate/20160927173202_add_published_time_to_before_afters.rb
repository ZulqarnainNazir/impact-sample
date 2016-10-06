class AddPublishedTimeToBeforeAfters < ActiveRecord::Migration
  def change
    add_column :before_afters, :published_time, :time
  end
end
