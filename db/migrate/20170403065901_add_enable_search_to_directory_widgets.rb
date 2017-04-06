class AddEnableSearchToDirectoryWidgets < ActiveRecord::Migration
  def change
    add_column :directory_widgets, :enable_search, :boolean
  end
end
