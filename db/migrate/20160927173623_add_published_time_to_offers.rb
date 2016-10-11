class AddPublishedTimeToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :published_time, :time
  end
end
