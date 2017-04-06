class AddPublicLabelToDirectoryWidgets < ActiveRecord::Migration
  def change
    add_column :directory_widgets, :public_label, :string
  end
end
