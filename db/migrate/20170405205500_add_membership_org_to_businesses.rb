class AddMembershipOrgToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :membership_org, :boolean, default: false
  end
end
