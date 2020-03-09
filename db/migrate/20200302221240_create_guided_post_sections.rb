class CreateGuidedPostSections < ActiveRecord::Migration
  def change
    create_table :guided_post_sections do |t|
      t.text :heading
      t.text :content
      t.integer :kind
      t.references :sectionable, polymorphic: true, index: {:name => "index_on_sectionable"}

      t.timestamps null: false
    end
  end
end
