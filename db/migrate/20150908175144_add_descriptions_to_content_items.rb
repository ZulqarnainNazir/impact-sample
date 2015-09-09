class AddDescriptionsToContentItems < ActiveRecord::Migration
  def change
    add_column :before_afters, :meta_description, :text
    add_column :event_definitions, :meta_description, :text
    add_column :galleries, :meta_description, :text
    add_column :offers, :meta_description, :text
    add_column :posts, :meta_description, :text
    add_column :quick_posts, :meta_description, :text
  end
end
