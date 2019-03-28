class AddPrivateToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :private, :boolean, :default => false
  end
end
