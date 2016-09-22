class AddApptDaysToOpenings < ActiveRecord::Migration
  def change
    add_column :openings, :by_appt, :boolean
  end
end
