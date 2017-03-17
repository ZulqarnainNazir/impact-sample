class CreateSchedule < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
    	t.references :share
    	t.datetime :share_times, array: true, default: []
    	t.timestamps null: :false
    end
  end
end
