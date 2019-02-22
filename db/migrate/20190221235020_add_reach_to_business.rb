class AddReachToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :reach, :integer
  end
end
