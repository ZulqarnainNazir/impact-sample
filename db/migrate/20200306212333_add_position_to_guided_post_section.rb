class AddPositionToGuidedPostSection < ActiveRecord::Migration
  def change
    add_column :guided_post_sections, :position, :integer
  end
end
