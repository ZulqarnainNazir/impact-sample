class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :label
      t.string :boundry_coordinates

      t.timestamps null: false
    end
  end
end
