class AddProcessedStylesToImages < ActiveRecord::Migration
  def change
    add_column :images, :processed_styles, :text
  end
end
