class AddSlugToContentTypes < ActiveRecord::Migration
  def change
    add_column :before_afters, :slug, :text
    add_column :event_definitions, :slug, :text
    add_column :galleries, :slug, :text
    add_column :offers, :slug, :text
    add_column :posts, :slug, :text
    add_column :quick_posts, :slug, :text
    add_index :before_afters, [:id, :slug], unique: true
    add_index :event_definitions, [:id, :slug], unique: true
    add_index :galleries, [:id, :slug], unique: true
    add_index :offers, [:id, :slug], unique: true
    add_index :posts, [:id, :slug], unique: true
    add_index :quick_posts, [:id, :slug], unique: true
  end
end
