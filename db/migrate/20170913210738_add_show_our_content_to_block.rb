class AddShowOurContentToBlock < ActiveRecord::Migration
  def change
  	add_column :blocks, :show_our_content, :boolean, default: true
  end
end
