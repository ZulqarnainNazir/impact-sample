class AddFeedbackToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :feedback_id, :integer, null: false
  end
end
