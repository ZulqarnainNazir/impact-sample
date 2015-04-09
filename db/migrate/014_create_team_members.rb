class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.references :business, index: true, null: false
      t.integer :position, default: 0, nul: false
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :title
      t.string :description
      t.string :facebook_id
      t.string :google_plus_id
      t.string :linkedin_id
      t.string :twitter_id
      t.json :settings
      t.timestamps null: false
    end
  end
end
