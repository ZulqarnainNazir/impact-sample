class AddPublishedTimeToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :published_time, :datetime
  end
end
