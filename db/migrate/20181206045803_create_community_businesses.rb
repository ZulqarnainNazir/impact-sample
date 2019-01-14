class CreateCommunityBusinesses < ActiveRecord::Migration
  def change
    create_table :community_businesses do |t|
      t.references :community, index: true
      t.references :business, index: true
      t.boolean :anchor
      t.boolean :champion

      t.timestamps null: false
    end
  end
end
