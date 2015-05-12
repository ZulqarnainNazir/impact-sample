class UpdateLocationsGeocode < ActiveRecord::Migration
  def change
    reversible do |dir|
      [:latitude, :longitude].each do |col|
        dir.up { change_column :locations, col, :real }
        dir.down { change_column :locations, col, :decimal, precision: 10, scale: 6 }
      end
    end
  end
end
