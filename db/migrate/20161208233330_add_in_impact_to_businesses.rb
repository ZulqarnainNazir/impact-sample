class AddInImpactToBusinesses < ActiveRecord::Migration
  def up
    add_column :businesses, :in_impact, :boolean, :default => true
    Business.find_each do |business|
      business.in_impact = true
      business.save!
    end
  end
  def down
    remove_column :businesses, :in_impact
  end
end
