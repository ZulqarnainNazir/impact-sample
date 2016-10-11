class AddPublishedStatusToBeforeAfters < ActiveRecord::Migration
  def change
    add_column :before_afters, :published_status, :boolean
  end
end
