class AddHeadingPromptToGuidedPostPrompts < ActiveRecord::Migration
  def change
    add_column :guided_post_prompts, :heading_prompt, :text
  end
end
