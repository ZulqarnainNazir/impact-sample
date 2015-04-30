class UpdateBusinessData < ActiveRecord::Migration
  def change
    add_column :businesses, :values, :text
    add_column :businesses, :history, :text
    add_column :businesses, :vision, :text
    add_column :businesses, :community_involvement, :text
  end
end
