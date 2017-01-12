class AddLabelToReviewWidget < ActiveRecord::Migration
  def change
    add_column :review_widgets, :label, :string
  end
end
