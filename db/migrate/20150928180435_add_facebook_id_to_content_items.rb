class AddFacebookIdToContentItems < ActiveRecord::Migration
  def change
    add_column :before_afters, :facebook_id, :text
    add_column :event_definitions, :facebook_id, :text
    add_column :galleries, :facebook_id, :text
    add_column :offers, :facebook_id, :text
    add_column :posts, :facebook_id, :text
    add_column :quick_posts, :facebook_id, :text
  end
end
