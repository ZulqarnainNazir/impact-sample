class AddFacebookTokenToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :facebook_token, :text
  end
end
