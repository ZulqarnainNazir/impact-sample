class RemoveReviewsFeedbackIdConstraint < ActiveRecord::Migration
  def change
    change_column_null :reviews, :feedback_id, true
  end
end
