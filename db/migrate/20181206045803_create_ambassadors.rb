class CreateAmbassadors < ActiveRecord::Migration
  def change
    create_table :ambassadors do |t|
      t.references :community
      t.references :business
      t.boolean :anchor
      t.boolean :champion

      t.timestamps null: false
    end
  end
end
