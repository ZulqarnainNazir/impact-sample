class AddPromptIdToGuidedPostSections < ActiveRecord::Migration
  def change
    add_column :guided_post_sections, :guided_post_prompt_id, :integer, idnex: true
  end
end
