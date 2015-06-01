class AddPlanToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :plan, :integer, default: 0, null: false
  end
end
