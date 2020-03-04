class AddKindToGuidedPostPrompts < ActiveRecord::Migration
  def change
    add_column :guided_post_prompts, :kind, :integer, index: true
  end
end
