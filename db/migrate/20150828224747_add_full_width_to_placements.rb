class AddFullWidthToPlacements < ActiveRecord::Migration
  def change
    add_column :placements, :full_width, :boolean, default: :false, null: false
  end
end
