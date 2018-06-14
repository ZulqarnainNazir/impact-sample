class AddFollowerSummaryJobs < ActiveRecord::Migration
  def change
    SummaryJob.create(
      name: 'hourly_followers',
      description: 'An hourly notification of new Local Network followers'
    )
    SummaryJob.create(
      name: 'daily_followers',
      description: 'An daily notification of new Local Network followers'
    )
    SummaryJob.create(
      name: 'weekly_followers',
      description: 'An weekly notification of new Local Network followers'
    )
  end
end
