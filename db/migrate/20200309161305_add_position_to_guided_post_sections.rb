class AddPositionToGuidedPostSections < ActiveRecord::Migration
  def change
    add_column :guided_post_sections, :position, :integer, index: true
  end
end
