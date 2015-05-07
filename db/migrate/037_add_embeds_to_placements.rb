class AddEmbedsToPlacements < ActiveRecord::Migration
  def change
    add_column :placements, :embed, :text
    change_column_null :placements, :image_id, true
  end
end
