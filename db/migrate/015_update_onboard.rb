class UpdateOnboard < ActiveRecord::Migration
  def change
    add_column :businesses, :tagline, :string
    add_column :businesses, :year_founded, :integer
    add_column :businesses, :website_url, :string
    add_column :businesses, :kind, :integer, default: 0, null: false
    add_column :locations, :hide_email, :boolean, default: false, null: false
    add_column :locations, :external_service_area, :boolean, default: false, null: false
    add_column :locations, :service_area, :text
  end
end
