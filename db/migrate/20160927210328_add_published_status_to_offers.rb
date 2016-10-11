class AddPublishedStatusToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :published_status, :boolean
  end
end
