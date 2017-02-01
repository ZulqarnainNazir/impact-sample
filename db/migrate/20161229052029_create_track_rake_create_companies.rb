class CreateTrackRakeCreateCompanies < ActiveRecord::Migration
  def change
    create_table :track_rake_create_companies do |t|
      t.references :company, index: true
      t.references :company_location, index: true
      t.references :business, index: true
      t.references :location, index: true
      t.references :contact_company, index: true

      t.timestamps null: false
    end
  end
end
