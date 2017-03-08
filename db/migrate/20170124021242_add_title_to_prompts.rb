class AddTitleToPrompts < ActiveRecord::Migration
  def change
    add_column :prompts, :title, :string
  end
end
