class AddSlugToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :slug, :text

    Business.find_in_batches do |batch|
      batch.each do |business|
        business.generate_slug
        business.save
      end
    end
  end
end
