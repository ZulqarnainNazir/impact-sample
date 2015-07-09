class AddFeedbackToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :feedback_id, :integer, null: false
    remove_column :reviews, :serviced_at
  end
end
