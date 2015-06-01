class AddTimestampsToWebpages < ActiveRecord::Migration
  def change
    change_table :webpages do |t|
      t.timestamps
    end
  end
end
