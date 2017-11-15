class JobLocations < ActiveRecord::Migration
  def change
    create_table :job_locations do |t|
      t.references :job, index: true, null: false
      t.references :location, index: true, null: false
      t.timestamps null: false
    end
  end
end
