class AddTimeZoneToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :time_zone, :string
  end
end
