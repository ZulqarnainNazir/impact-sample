class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :business, index: true, null: false
      t.text :title, null: false
      t.text :offer, null: false
      t.text :description
      t.timestamps null: false
    end
  end
end
