class CreateSummaryJobs < ActiveRecord::Migration
  def change
    create_table :summary_jobs do |t|
      t.string :name
      t.string :description
      t.timestamp :last_run_at

      t.timestamps null: false
    end
  end
end
