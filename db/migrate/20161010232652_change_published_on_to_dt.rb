class ChangePublishedOnToDt < ActiveRecord::Migration
  def change
    remove_column :before_afters, :published_on, :date
    remove_column :galleries, :published_on, :date
    remove_column :offers, :published_on, :date
    remove_column :quick_posts, :published_on, :date
    remove_column :posts, :published_on, :date

    add_column :before_afters, :published_on, :datetime
    add_column :galleries, :published_on, :datetime
    add_column :offers, :published_on, :datetime
    add_column :quick_posts, :published_on, :datetime
    add_column :posts, :published_on, :datetime
  end
end
