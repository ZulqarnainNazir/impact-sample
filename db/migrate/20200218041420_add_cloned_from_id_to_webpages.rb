class AddClonedFromIdToWebpages < ActiveRecord::Migration
  def change
    add_column :webpages, :cloned_from_id, :integer, after: :website_id
  end
end
