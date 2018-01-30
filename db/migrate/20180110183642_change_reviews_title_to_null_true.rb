class ChangeReviewsTitleToNullTrue < ActiveRecord::Migration
  def change
  	change_column :reviews, :title, :text, :null => true
  end
end
